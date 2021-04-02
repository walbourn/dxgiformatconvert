// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R16G16_FLOAT Test Shader
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
            values.HLSLResult = uint4(asuint(D3DX_R16G16_FLOAT_to_FLOAT2(values.testVal)),0,0);
            values.outVal = D3DX_FLOAT2_to_R16G16_FLOAT(asfloat(values.RefResult.xy));
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = asuint(float4(65537,-65537,65537,-65537));
        values.HLSLResult = asuint(float4(65536,-65536,65536,-65536));
        values.testVal = D3DX_FLOAT2_to_R16G16_FLOAT(asfloat(values.RefResult.xy));
        values.outVal = D3DX_FLOAT2_to_R16G16_FLOAT(asfloat(values.HLSLResult.xy));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
