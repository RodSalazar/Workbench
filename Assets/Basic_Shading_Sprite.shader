Shader "Unlit/Basic_Shading_Sprite"
{
	Properties
	{
		_MainColor ("Color", Color) = (0.5,0.5,0.5)
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100

		Pass
		{
			ZWrite Off // don't write to depth buffer 
            // in order not to occlude other objects
			Blend SrcAlpha OneMinusSrcAlpha // use alpha blending

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = _MainColor * unity_AmbientSky;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = i.color * tex2D(_MainTex, i.uv) ;
				return col;
			}
			ENDCG
		}
	}
}
