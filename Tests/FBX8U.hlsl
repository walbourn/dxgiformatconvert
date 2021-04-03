// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// B8G8R8X8_UNORM Test Shader
//-----------------------------------------------------------------------------
[numthreads(1,1,1)]
void main()
{
    for(uint y = 0; y < uUINT.Length.y; y++)
    {
        for(uint x = 0; x < uUINT.Length.x; x++)
        {
            VALUES values;
            values.testVal = uUINT[uint2(x,y)];
            values.RefResult = uint4(asuint(tfRefConversion.Load(uint3(x,y,0)).xyz),asuint(1.0f));
            values.HLSLResult = float4(asuint(D3DX_B8G8R8X8_UNORM_to_FLOAT3(values.testVal)),asuint(1.0f));
            values.outVal = D3DX_FLOAT3_to_B8G8R8X8_UNORM(asfloat(values.RefResult.xyz));
            if( any(values.RefResult != values.HLSLResult) || ((values.testVal&0x00ffffff) != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0xffffffff,asuint(1.1f),asuint(-0.2f),asuint(1.0f));
        values.HLSLResult = uint4(0,asuint(1.0f),0,asuint(1.0f));
        values.testVal = D3DX_FLOAT3_to_B8G8R8X8_UNORM(asfloat(values.RefResult.xyz));
        values.outVal = D3DX_FLOAT3_to_B8G8R8X8_UNORM(asfloat(values.HLSLResult.xyz));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
