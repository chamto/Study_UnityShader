
//사용자 정의 라이팅 모델 
//https://docs.unity3d.com/Manual/SL-SurfaceShaderLighting.html
//Cg 내장함수 
//http://developer.download.nvidia.com/CgTutorial/cg_tutorial_appendix_e.html
//Unity shader dataType
//https://docs.unity3d.com/Manual/SL-DataTypesAndPrecision.html
//유니티 Built-in shader variables
//https://docs.unity3d.com/Manual/SL-UnityShaderVariables.html

//밸브 "캐릭터 라이팅"
//http://www.valvesoftware.com/publications/2007/NPAR07_IllustrativeRenderingInTeamFortress2.pdf
//정오표
//https://www.packtpub.com/books/content/support/11712

Shader "Cookbook_First/Chapter_01/Diffuse_Ramp_BRDF" 
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


		//ref : http://coreafive.egloos.com/7319419
		// atten은 조명강도.
        // _LightColor0은 빛의 색.
        // unity4까지는 조명강도는 x2를 해주어야 했지만 5부터는 더 이상 하지 않아도 된다.
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
			col.rgb = s.Albedo * _LightColor0.rgb * (ramp); //3
			//col.rgb = ramp;
			col.a = s.Alpha;
			return col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
