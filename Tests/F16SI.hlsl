// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R16G16_SINT Test Shader
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
            values.RefResult = asuint(int4(tsiRefConversion.Load(uint3(x,y,0)).xy,0,0));
            values.HLSLResult = asuint(int4(D3DX_R16G16_SINT_to_INT2(values.testVal),0,0));
            values.outVal = D3DX_INT2_to_R16G16_SINT(asint(values.RefResult.xy));
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0x80000000,0xffff7fff,0x80000000,0xffff7fff);
        values.HLSLResult = uint4(0xFFFF8000,0xFFFF8000,0xFFFF8000,0xFFFF8000);
        values.testVal = asuint(D3DX_INT2_to_R16G16_SINT(asint(values.RefResult.xy)));
        values.outVal = asuint(D3DX_INT2_to_R16G16_SINT(asint(values.HLSLResult.xy)));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
        values.RefResult = uint4(0x80000000,0xffff7fff,0x80000000,0xffff7fff);
        values.HLSLResult = uint4(0xFFFF8000,0xFFFF8000,0xFFFF8000,0xFFFF8000);
        values.testVal = asuint(D3DX_INT2_to_R16G16_SINT(asint(values.RefResult.xy)));
        values.outVal = asuint(D3DX_INT2_to_R16G16_SINT(asint(values.HLSLResult.xy)));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
