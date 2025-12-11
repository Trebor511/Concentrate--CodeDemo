// an ultra simple hlsl pixel shader
// TODO: Part 3A 
// TODO: Part 4B 
// TODO: Part 4C 
// TODO: Part 4F 

struct Material
{
	float3    Kd; // diffuse reflectivity
	float	    d; // dissolve (transparency) 
	float3    Ks; // specular reflectivity
	float       Ns; // specular exponent
	float3    Ka; // ambient reflectivity
	float       sharpness; // local reflection map sharpness
	float3    Tf; // transmission filter
	float       Ni; // optical density (index of refraction)
	float3    Ke; // emissive reflectivity
	unsigned int   illum; // illumination model
};

cbuffer ShaderMats : register(b0)
{
	float4x4 world[500];
	float4x4 view;
	float4x4 projection;
};

cbuffer ShaderCol : register(b1)
{
	float4 lightDir;
	float4 lightCol;
	Material mat[500];
	float4 camPosition;
	float4 ambientLight;
};

cbuffer MaterMatriOffset : register(b2)
{
	uint worldMatrixIndex;
	uint materialIndex;
	uint pad1;
	uint pad2;
};

Texture2D color : register(t0);
SamplerState filter : register(s0);

struct outRaster
{
	float4 xyzw : SV_POSITION;
	float3 worldPos : WORLD;
	float3 norm : NORMAL;
	float2 uv : UVCOORDS;
};


float4 main(outRaster input) : SV_TARGET
{	
	Material mater = mat[materialIndex];
	float4 color = (float4)0;
	float ratio = 0;
	float3 totalDir = (float3)0;
	ratio = saturate(dot(-normalize(float3(lightDir.xyz)), normalize(input.norm)));
	totalDir = mul(ratio, float3(lightCol.xyz));

	float3 camPos = float3(.0f, .0f, 0.0f);// camPosition.xyz;
	float3 viewDir = normalize(camPos - input.worldPos);
	float3 halfVec = normalize(-(normalize(lightDir.xyz)) + normalize(viewDir));
	float intensity = max(pow(saturate(dot(normalize(input.norm), halfVec)), (mater.Ns+.00000001f)), 0);

	float4 matKs = float4(mater.Ks, 0) * intensity;
	float4 sunAmbient = ambientLight * float4(mater.Ka, 1);

	color.xyz = saturate(totalDir + sunAmbient) * mater.Kd + matKs + mater.Ke;

	//float colMax = max(max(color.xyz.x, color.xyz.y), color.xyz.z);
	//color.xyz.x = colMax; color.xyz.y = colMax; color.xyz.z = colMax;

	//return float4(mater.Kd, 1.0);

	return color; // TODO: Part 1A (optional) 
}