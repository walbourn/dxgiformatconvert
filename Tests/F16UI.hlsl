// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R16G16_UINT Test Shader
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
            values.RefResult = uint4(tuiRefConversion.Load(uint3(x,y,0)).xy,0,0);
            values.HLSLResult = uint4(D3DX_R16G16_UINT_to_UINT2(values.testVal),0,0);
            values.outVal = D3DX_UINT2_to_R16G16_UINT(values.RefResult.xy);
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0xffffffff,0x00010000,0xffffffff,0x00010000);
        values.HLSLResult = uint4(0x0000ffff,0x0000ffff,0x0000ffff,0x0000ffff);
        values.testVal = D3DX_UINT2_to_R16G16_UINT(values.RefResult.xy);
        values.outVal = D3DX_UINT2_to_R16G16_UINT(values.HLSLResult.xy);
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
