// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "fmtconverttest.hlsli"

//-----------------------------------------------------------------------------
// R10G10B10A2_UINT Test Shader
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
            values.RefResult = tuiRefConversion.Load(uint3(x,y,0));
            values.HLSLResult = D3DX_R10G10B10A2_UINT_to_UINT4(values.testVal);
            values.outVal = D3DX_UINT4_to_R10G10B10A2_UINT(values.RefResult);
            if( any(values.RefResult != values.HLSLResult) || (values.testVal != values.outVal) )
            {
                uErrors.Append(values);
            }
        }
    }
    if( uUINT[uint2(0,0)] == 0 )
    {
        VALUES values;
        values.RefResult = uint4(0xffffffff,0x00000400,0,0x00000004);
        values.HLSLResult = uint4(0x000003ff,0x000003ff,0x00000000,0x00000003);
        values.testVal = D3DX_UINT4_to_R10G10B10A2_UINT(values.RefResult);
        values.outVal = D3DX_UINT4_to_R10G10B10A2_UINT(values.HLSLResult);
        if( values.testVal != values.outVal )
        {
            uErrors.Append(values);
        }
    }
}
