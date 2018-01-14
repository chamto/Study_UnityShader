Shader "CookbookShaders/Diffuse_TestDiff" 
{
	Properties 
	{
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
		//_Glossiness     ("Smoothness", Range(0, 1)) = 0.5
        //_Metallic         ("Metallic", Range(0, 1))    = 0.0
		_RampTex ("Ramp Texture",2D) = "white"
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf BasicDiffuse //사용자 정의 라이팅 모델

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		//half    _Glossiness;
        //half    _Metallic;
		sampler2D _RampTex;

		struct Input 
		{
			float2 uv_MainTex;
		};



		void surf (Input IN, inout SurfaceOutput o) 
		{
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			//o.Metallic = _Metallic;
            //o.Smoothness = _Glossiness;
			o.Alpha = c.a;

		}



		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			
			//float difLight = max(0, dot(s.Normal, lightDir)); //1 - basic lambert
			float difLight = dot(s.Normal, lightDir);
			float rimLight = dot(s.Normal, viewDir);
			//float rimLight = max(0, dot(s.Normal, viewDir));
			float hLambert = difLight * 0.5 + 0.5; //2 - half lambert
			float3 ramp = tex2D(_RampTex, float2(hLambert,rimLight)).rgb; //3
			//float3 ramp = tex2D(_RampTex, float2(hLambert,1)).rgb; //3


			float4 col;
			//col.rgb = s.Albedo * _LightColor0.rgb * (ramp); //3
			//col.rgb = ramp * _Time;
			col.rgb = ramp;
			col.a = s.Alpha;
			return col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
