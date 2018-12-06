Shader "Unlit/Test"
{
    Properties
    {
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Texture", 2D) = "white" { }
        _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" "PreviewType" = "Plane" }
		
		/*
			---BLEND MODES---
		
			Blend consists on the relation between your Source pixels (The ones your shader provides)
			against the Destination pixels (the ones already on the screen).

			This means that the formula for it would be Source * SourceBlendType + Destination * DestinationBlendType.

			Example:	One-One blend (Additive) -> Source * 1 + Destination * 1 
						SrcAlpha OneMinusSrcAlpha (Traditional Transparent) -> Source * Source Alpha Value + Destination * (1 - Source Alpha Value)
						One OneMinusSrcAlpha (Premultiplied Transparent) -> Source * 1 + Destination * (1 - Source Alpha Value)
						

		*/
        
		Blend One OneMinusSrcColor
        ColorMask RGB
        Cull Off Lighting Off ZWrite Off
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
				float4 color: COLOR;
            };

            struct v2f
            {
				float4 vertex: SV_POSITION;
                float2 uv: TEXCOORD0;
				float4 color: COLOR;
                float4 projPos: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _TintColor;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                 //
                o.projPos = ComputeScreenPos(o.vertex);
                COMPUTE_EYEDEPTH(o.projPos.z);
				//
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.color = v.color * _TintColor;
                
               
                return o;
            }

            //
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
			float _InvFade;
            //
            
            fixed4 frag(v2f i): SV_Target
            {
                //
                float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
				float partZ = i.projPos.z;
				float fade = saturate (_InvFade * (sceneZ-partZ));
				i.color.a *= fade;
                //
                
                half4 col = i.color * tex2D(_MainTex, i.uv);
                col.rgb *= col.a;
                return (col * i.color);
            }
            ENDCG
            
        }
    }
}
