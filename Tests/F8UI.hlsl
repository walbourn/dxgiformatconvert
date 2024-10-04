// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R8G8B8A8_UINT Test Shader
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
            values.RefResult = tuiRefConversion.Load(uint3(x,y,0));
            values.HLSLResult = D3DX_R8G8B8A8_UINT_to_UINT4(values.testVal);
            values.outVal = D3DX_UINT4_to_R8G8B8A8_UINT(values.RefResult);
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0xffffffff,0x00000100,0xffffffff,0x00000100);
        values.HLSLResult = uint4(0x000000ff,0x000000ff,0x000000ff,0x000000ff);
        values.testVal = D3DX_UINT4_to_R8G8B8A8_UINT(values.RefResult);
        values.outVal = D3DX_UINT4_to_R8G8B8A8_UINT(values.HLSLResult);
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
