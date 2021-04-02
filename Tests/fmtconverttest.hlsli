#include "..\D3DX_DXGIFormatConvert.inl"

//-----------------------------------------------------------------------------
// Declare buffers
//-----------------------------------------------------------------------------
Texture2D<float4> tfRefConversion : register(t0);
Texture2D<uint4> tuiRefConversion : register(t0);
Texture2D<int4> tsiRefConversion : register(t0);

struct VALUES
{
    uint testVal;
    uint4 HLSLResult;
    uint4 RefResult;
    uint outVal;
};

RWTexture2D<uint> uUINT : register(u0);
AppendStructuredBuffer<VALUES> uErrors : register(u1);
