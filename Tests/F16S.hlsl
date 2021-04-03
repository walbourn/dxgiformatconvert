// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R16G16_SNORM Test Shader
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
            values.RefResult = uint4(asuint(tfRefConversion.Load(uint3(x,y,0)).xy),0,0);
            values.HLSLResult = uint4(asuint(D3DX_R16G16_SNORM_to_FLOAT2(values.testVal)),0,0);
            values.outVal = D3DX_FLOAT2_to_R16G16_SNORM(asfloat(values.RefResult.xy));
            uint cmpval = values.testVal;
            if( (cmpval.r & 0xffff0000) == 0x80000000 )
            {
                cmpval |= 0x00010000;
            }
            if( (cmpval.r & 0x0000ffff) == 0x00008000 )
            {
                cmpval |= 0x00000001;
            }
            if( any(values.RefResult != values.HLSLResult) || (cmpval != values.outVal) )
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
        values.testVal = D3DX_FLOAT2_to_R16G16_SNORM(asfloat(values.RefResult.xy));
        values.outVal = D3DX_FLOAT2_to_R16G16_SNORM(asfloat(values.HLSLResult.xy));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
        values.RefResult = uint4(asuint(-1.1f),0x7f800000,asuint(-1.1f),0x7f800000);
        values.HLSLResult = uint4(asuint(-1.0f),asuint(1.0f),asuint(-1.0f),asuint(1.0f));
        values.testVal = D3DX_FLOAT2_to_R16G16_SNORM(asfloat(values.RefResult.xy));
        values.outVal = D3DX_FLOAT2_to_R16G16_SNORM(asfloat(values.HLSLResult.xy));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
