// an ultra simple hlsl vertex shader
// TODO: Part 1F 
// TODO: Part 1H 
// TODO: Part 2B 
// TODO: Part 2D 
// TODO: Part 4A 
// TODO: Part 4B 
#pragma pack_matrix(row_major)

struct ObjVert
{
	float3 xyz : POSITION;
	float3 uvw : COLOR;
	float3 nrm : NORMAL;
};

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

struct outRaster
{
	float4 xyzw : SV_POSITION;
	float3 worldPos : WORLD;
	float3 norm : NORMAL;
	float2 uv : UVCOORDS;
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

cbuffer SPRITE_DATA : register(b3)
{
	float2 pos_offset;
	float2 scale;
	float rotation;
	float depth;
};

outRaster main(ObjVert input, uint id: SV_INSTANCEID)
{
	outRaster output = (outRaster)0;
	output.xyzw = float4(input.xyz, 1);

	output.xyzw = mul(output.xyzw, world[worldMatrixIndex + id]);
	output.worldPos = output.xyzw.xyz;
	output.norm = mul(float4(input.nrm, 0), world[worldMatrixIndex + id]).xyz;

	output.xyzw = mul(output.xyzw, view);

	output.xyzw = mul(output.xyzw, projection);
	output.uv = float2(input.uvw.x, input.uvw.y);

	return output;
}