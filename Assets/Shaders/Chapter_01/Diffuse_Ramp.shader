
//사용자 정의 라이팅 모델 
//https://docs.unity3d.com/Manual/SL-SurfaceShaderLighting.html
//Cg 내장함수 
//http://developer.download.nvidia.com/CgTutorial/cg_tutorial_appendix_e.html
//Unity shader dataType
//https://docs.unity3d.com/Manual/SL-DataTypesAndPrecision.html
//밸브 "캐릭터 라이팅"
//http://www.valvesoftware.com/publications/2007/NPAR07_IllustrativeRenderingInTeamFortress2.pdf
//정오표
//https://www.packtpub.com/books/content/support/11712

Shader "CookbookShaders/Diffuse_Ramp" 
{
	Properties 
	{
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
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
			o.Alpha = c.a;

		}


		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			
			float difLight = max(0, dot(s.Normal, lightDir)); //1 - basic lambert
			float hLambert = difLight * 0.5 + 0.5; //2 - half lambert
			float3 ramp = tex2D(_RampTex, (float2)hLambert).rgb; //3
			//float3 ramp = tex2D(_RampTex, float2(hLambert,1)).rgb; //3

			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (ramp); //3
			//col.rgb = ramp;
			col.a = s.Alpha;
			return col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
