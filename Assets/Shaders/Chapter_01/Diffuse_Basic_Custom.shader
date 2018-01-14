
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

Shader "CookbookShaders/Diffuse_Basic_Custom" 
{
	Properties 
	{
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		//#pragma surface surf Lambert //유니티 내장 디퓨즈라이팅
		#pragma surface surf BasicDiffuse //사용자 정의 라이팅 모델

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;


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

			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2); //1
			col.a = s.Alpha;
			return col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
