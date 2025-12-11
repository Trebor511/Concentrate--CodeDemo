// an ultra simple hlsl vertex shader
// TODO: Part 1F 
// TODO: Part 1H 
// TODO: Part 2B 
// TODO: Part 2D 
// TODO: Part 4A 
// TODO: Part 4B 
#pragma pack_matrix(row_major)

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

struct VS_IN
{
	float2 pos : POSITION;
	float2 uv : TEXCOORD;
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

outRaster main(VS_IN input)
{
	outRaster output = (outRaster)0;

	float2 r = float2(cos(rotation), sin(rotation));
	float2x2 rotate = float2x2(r.x, -r.y, r.y, r.x);
	float2 pos = pos_offset + mul(rotate, input.pos * scale);

	output.xyzw = float4(pos, depth, 1.0f);
	output.norm = float3(0, 0, 0);
	output.worldPos = float3(0, 0, 0);
	output.uv = input.uv;

	return output;
}