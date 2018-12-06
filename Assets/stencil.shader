Shader "Unlit/Stencil"
{
    Properties()
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TintCol ("Tint Color", Color) = (0.5,0.5,0.5,1)
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp ("Stencil Comparison", float) = 8
        _Stencil ("Stencil ID", float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp ("Stencil Operation", float) = 0
        _StencilWriteMask ("Stencil Write Mask", float) = 255
        _StencilReadMask ("Stencil Read Mask", float) = 255
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Stencil
        {
            /* Unity Link: https://docs.unity3d.com/Manual/SL-Stencil.html
            Stencil Operations:

            0 - Keep    > Keeps the current stencil value.
            1 - Zero    > The stencil value is set to 0.
            2 - Replace > Replace the stencil buffer value with reference value (Ref [_Stencil]).
            3 - IncrementSaturate   > Increments the current stencil buffer value by 1. Clamps to 255.
            4 - DecrementSaturate   > Decrements the current stencil buffer value by 1. Clamps to 0.
            5 - Invert  > Bitwise inverts the current stencil buffer value.
            6 - IncrementWrap   > Increments the current stencil buffer value. Wraps back to 0.
            7 - DecrementWrap   > Decrements the current stencil buffer value. Wraps back to 255.


            Comparison Funcions:

            0 - Always (Also used from 8 and above)
            1 - Never
            2 - Less
            3 - Equal
            4 - LEqual
            5 - Greater
            6 - NotEqual
            7 - GEqual
            */

            Ref [_Stencil] //Ref is the Stencil ID
            Comp [_StencilComp]
            Pass [_StencilOp] 
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _TintCol;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed3 col = _TintCol;
                return float4(col,1);
            }
            ENDCG
        }
    }
}