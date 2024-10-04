// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R8G8B8A8_SINT Test Shader
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
            values.RefResult = asuint(tsiRefConversion.Load(uint3(x,y,0)));
            values.HLSLResult = asuint(D3DX_R8G8B8A8_SINT_to_INT4(values.testVal));
            values.outVal = D3DX_INT4_to_R8G8B8A8_SINT(asint(values.RefResult));
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0x80000000,0xffffff7f,0x80000000,0xffffff7f);
        values.HLSLResult = uint4(0xFFFFFF80,0xFFFFFF80,0xFFFFFF80,0xFFFFFF80);
        values.testVal = asuint(D3DX_INT4_to_R8G8B8A8_SINT(asint(values.RefResult)));
        values.outVal = asuint(D3DX_INT4_to_R8G8B8A8_SINT(asint(values.HLSLResult)));
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
