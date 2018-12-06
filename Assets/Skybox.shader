Shader "Unlit/Skybox"
{
	Properties
	{
		_UpVector ("Up Vector", Vector) = (0, 1, 0, 0)
		_Color1 ("Color 1", Color) = (1, 1, 1, 0)
        _Color2 ("Color 2", Color) = (1, 1, 1, 0)
	}

	SubShader
	{
		Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
		Cull Off ZWrite Off

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
				float lightAngle : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float lightAngle : TEXCOORD1;
			};

			fixed3 _lightDir;
			half4 _UpVector;
			half4 _Color1;
			half4 _Color2;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				_lightDir = normalize( _WorldSpaceLightPos0.xyz );
				o.lightAngle = dot(_lightDir, _UpVector) * 0.5 + 0.5;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed col = i.lightAngle * (i.uv.y * 0.5 + 0.5) ;
				fixed4 color = lerp(_Color2,_Color1, col);
				return color;
			}
			ENDCG
		}
	}
}
