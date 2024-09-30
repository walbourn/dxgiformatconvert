// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R8G8B8A8_UNORM Test Shader
//-----------------------------------------------------------------------------
[numthreads(1,1,1)]
void main()
{
    uint width, height;
    uUINT.GetDimensions(width, height);

    for(uint y = 0; y < height; y++)
    {
        for(uint x = 0; x < width; x++)
        {
            VALUES values;
            values.testVal = uUINT[uint2(x,y)];
            values.RefResult = asuint(tfRefConversion.Load(uint3(x,y,0)));
            values.HLSLResult = asuint(D3DX_R8G8B8A8_UNORM_to_FLOAT4(values.testVal));
            values.outVal = D3DX_FLOAT4_to_R8G8B8A8_UNORM(asfloat(values.RefResult));
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0xffffffff,asuint(1.1f),asuint(-0.2f),0x7f800000);
        values.HLSLResult = asuint(float4(0,1,0,1));
        values.testVal = D3DX_FLOAT4_to_R8G8B8A8_UNORM(asfloat(values.RefResult));
        values.outVal = D3DX_FLOAT4_to_R8G8B8A8_UNORM(asfloat(values.HLSLResult));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
