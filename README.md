# D3DX_DXGIFormatConvert.inl

This utility header was introduced in the legacy DirectX SDK in June 2010.

> The new D3DX_DXGIFormatConvert.inl inline header includes light-weight conversion functions for use in Compute Shaders or Pixel Shaders on D3D11 Hardware that can be useful when applications need to simultaneously read and write to textures, such as in-place editing scenarios.

This repro contains the latest updates to this header, which is included in the [Microsoft.DXSDK.D3DX](https://www.nuget.org/packages/Microsoft.DXSDK.D3DX) NuGet package.

Documentation can be found on [Microsoft Docs](https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl-unpacking-packing-dxgi-format)

## Notices

This header is made available subject to the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.

# Version History

April 2021 - Updated to use DirectXMath in the Windows SDK instead of legacy XNAMath from the DirectX SDK for C++ support

June 2010 - Release in legacy DirectX SDK
