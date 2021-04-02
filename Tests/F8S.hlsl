// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R8G8B8A8_SNORM Test Shader
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
            values.HLSLResult = asuint(D3DX_R8G8B8A8_SNORM_to_FLOAT4(values.testVal));
            values.outVal = D3DX_FLOAT4_to_R8G8B8A8_SNORM(asfloat(values.RefResult));
            uint cmpval = values.testVal;
            if( (cmpval & 0xff000000) == 0x80000000 )
            {
                cmpval |= 0x01000000;
            }
            if( (cmpval & 0x00ff0000) == 0x00800000 )
            {
                cmpval |= 0x00010000;
            }
            if( (cmpval & 0x0000ff00) == 0x00008000 )
            {
                cmpval |= 0x00000100;
            }
            if( (cmpval & 0x000000ff) == 0x00000080 )
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
        values.RefResult = uint4(0xffffffff,asuint(1.1f),asuint(-1.1f),0x7f800000);
        values.HLSLResult = asuint(float4(0,1,-1,1));
        values.testVal = D3DX_FLOAT4_to_R8G8B8A8_SNORM(asfloat(values.RefResult));
        values.outVal = D3DX_FLOAT4_to_R8G8B8A8_SNORM(asfloat(values.HLSLResult));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
