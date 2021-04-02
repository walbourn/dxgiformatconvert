// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// B8G8R8A8_UNORM Test Shader
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
            values.RefResult = asuint(tfRefConversion.Load(uint3(x,y,0)));
            values.HLSLResult = asuint(D3DX_B8G8R8A8_UNORM_to_FLOAT4(values.testVal));
            values.outVal = D3DX_FLOAT4_to_B8G8R8A8_UNORM(asfloat(values.RefResult));
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
        values.HLSLResult = uint4(0,asuint(1.0f),0,asuint(1.0f));
        values.testVal = D3DX_FLOAT4_to_B8G8R8A8_UNORM(asfloat(values.RefResult));
        values.outVal = D3DX_FLOAT4_to_B8G8R8A8_UNORM(asfloat(values.HLSLResult));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
