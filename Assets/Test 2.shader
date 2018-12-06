Shader "Unlit/ParticleAdditiveTest"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (0.5, 0.5, 0.5, 1)
        _AccentColor ("Accent Color", Color) = (0.5, 0.5, 0.5, 1)
        _MainTex ("Texture", 2D) = "white" { }
        _DistortTex ("Distorion Texture", 2D) = "white" { }

        _Slider ("Slider", Range (0,2)) = 0.0
        [Toggle(USEDEPTH)]_useDepth ("Toggle Soft Particles", float) = 0.0
         _InvFade ("Soft Particles Factor", Range(0.01, 3.0)) = 1.0

        
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
        
        Blend One OneMinusSrcAlpha
        ColorMask RGB
        Cull Off Lighting Off ZWrite Off
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature USEDEPTH
            
            
            #include "UnityCG.cginc"

            struct appdata
            {
                fixed4 vertex: POSITION;
                fixed4 uv: TEXCOORD0;
                fixed4 color: COLOR;
            };

            struct v2f
            {
                fixed4 vertex: SV_POSITION;
                fixed4 uv: TEXCOORD0;
                fixed4 color: COLOR;

                #if USEDEPTH
                    float4 projPos: TEXCOORD1;
                #endif
            };

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed4 _DistortTex_ST;
            sampler2D _DistortTex;
            fixed4 _MainColor;
            fixed4 _AccentColor;
            fixed _Slider;
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                #if USEDEPTH
                    o.projPos = ComputeScreenPos(o.vertex);
                    COMPUTE_EYEDEPTH(o.projPos.z);
                #endif

                o.uv = v.uv.xyxy;
                o.color = v.color;
                
                
                return o;
            }

            #if USEDEPTH
                UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
                float _InvFade;
            #endif
            
            fixed4 frag(v2f i): SV_Target
            {

                
                #if USEDEPTH
                    float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                    float partZ = i.projPos.z;
                    float fade = saturate(_InvFade * (sceneZ - partZ));
                    i.color.rgb *= fade;
                #endif
                
                i.uv.x -= _Time * 5;
                i.uv.y -= _Time * 10;
                half2 distortion = tex2D(_DistortTex, i.uv.xy).rg;
                //i.uv.y += distortion * _Slider * i.uv.w;
                i.uv.w += (distortion.r * distortion.g) * _Slider * i.uv.w;

                half2 base = i.color * tex2D(_MainTex, i.uv.zw).rg;

                half4 col = base.r * _MainColor + _AccentColor * base.g;

                return col;
            }
            ENDCG
            
        }
    }
}
