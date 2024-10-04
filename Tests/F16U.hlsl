// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R16G16_UNORM Test Shader
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
            values.RefResult = uint4(asuint(tfRefConversion.Load(uint3(x,y,0)).xy),0,0);
            values.HLSLResult = uint4(asuint(D3DX_R16G16_UNORM_to_FLOAT2(values.testVal)),0,0);
            values.outVal = D3DX_FLOAT2_to_R16G16_UNORM(asfloat(values.RefResult.xy));
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0xffffffff,asuint(1.1f),0xffffffff,asuint(1.1f));
        values.HLSLResult = uint4(0,asuint(1.0f),0,asuint(1.0f));
        values.testVal = D3DX_FLOAT2_to_R16G16_UNORM(asfloat(values.RefResult.xy));
        values.outVal = D3DX_FLOAT2_to_R16G16_UNORM(asfloat(values.HLSLResult.xy));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
        values.RefResult = uint4(asuint(-0.2f),0x7f800000,asuint(-0.2f),0x7f800000);
        values.HLSLResult = uint4(0,asuint(1.0f),0,asuint(1.0f));
        values.testVal = D3DX_FLOAT2_to_R16G16_UNORM(asfloat(values.RefResult.xy));
        values.outVal = D3DX_FLOAT2_to_R16G16_UNORM(asfloat(values.HLSLResult.xy));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
