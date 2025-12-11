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
	return color.Sample(filter, input.uv);
	float4 x = color.Sample(filter, input.uv).xyzw;
	float colMax = max(max(x.xyz.x, x.xyz.y), x.xyz.z);
	x.xyz.x = colMax; x.xyz.y = colMax; x.xyz.z = colMax;
}