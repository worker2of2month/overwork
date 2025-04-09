// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "CYF/Wave3"
{
    Properties
    {
        _MainTex("Sprite Texture", 2D) = "white" {}

        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255

        _ColorMask("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0



        Width("Width Change Size", float) = 1
        Rate("Width Change Rate", float) = 1
        Time("Time", float) = -1
		Height1("Height where the wave starts, with 0 being the bottom of the sprite and 1 the top", Range (0.00, 1.00)) = 0
		Height2("Height where the wave ends, with 0 being the bottom of the sprite and 1.3 the top", Range (0.00, 1.30)) = 1.3
		old_x("Absolute x position of the sprite from the center", float) = 0
    }

        SubShader
        {
            Tags
            {
                "Queue" = "Transparent"
                "IgnoreProjector" = "True"
                "RenderType" = "Transparent"
                "PreviewType" = "Plane"
                "CanUseSpriteAtlas" = "True"
            }

            Stencil
            {
                Ref[_Stencil]
                Comp[_StencilComp]
                Pass[_StencilOp]
                ReadMask[_StencilReadMask]
                WriteMask[_StencilWriteMask]
            }

            Cull Off
            Lighting Off
            ZWrite Off
            ZTest[unity_GUIZTestMode]
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask[_ColorMask]

            Pass
            {
                Name "Default"
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 2.0

                #include "UnityCG.cginc"
                #include "UnityUI.cginc"

                #pragma multi_compile __ UNITY_UI_CLIP_RECT
                #pragma multi_compile __ UNITY_UI_ALPHACLIP
                #pragma multi_compile __ NO_PIXEL_SNAP
                #pragma multi_compile __ NO_WRAP
                #pragma multi_compile __ CROP
                #pragma multi_compile __ CUSTOM_TIME

                struct appdata_t
                {
                    float4 vertex   : POSITION;
                    float4 color    : COLOR;
                    float2 texcoord : TEXCOORD0;
                    UNITY_VERTEX_INPUT_INSTANCE_ID
                };

                struct v2f
                {
                    float4 vertex   : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 uv : TEXCOORD0;
                    float4 worldPosition : TEXCOORD1;
                    UNITY_VERTEX_OUTPUT_STEREO
                };

                sampler2D _MainTex;
                uniform float4 _MainTex_TexelSize;
                fixed4 _TextureSampleAdd;
                float4 _ClipRect;
                float4 _MainTex_ST;

                float Width;
                float Rate;
                float Time;
				float Height1;
				float Height2;
				float old_x;
				
                v2f vert(appdata_t v)
                {
                    v2f OUT;
                    UNITY_SETUP_INSTANCE_ID(v);
                    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                    OUT.worldPosition = v.vertex;
					
                    #ifndef CROP	
                    OUT.worldPosition.x *= max(abs(Width), 3);
					OUT.worldPosition.x += old_x * (max(abs(Width), 3) - 1);
                    #endif
                    OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
					
                    OUT.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                    OUT.color = v.color;
                    return OUT;
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    float2 offset = IN.uv;

                    #ifndef CROP
                    offset.x -= 0.5;
                    offset.x *= max(abs(Width), 3);
                    offset.x += 0.5;
                    #endif
					
					float h = Height2 - IN.uv.y;
					if (IN.uv.y >= Height1 && h >= Height1)
					{
						if (h >= Height1 + 0.3)
						{
							h = 1;
						}
						else
						{
							h *= 3.3;
						}
					}
					else
					{
						h = 0;
					}

                    #ifndef CUSTOM_TIME
					
                    offset.x += h * sin((_Time.y + IN.uv.y * Rate)) / 5 * Width;
                    #endif

                    #ifdef CUSTOM_TIME
                    offset.x += h * sin((Time + IN.uv.y * Rate)) / 5 * Width;
                    #endif

                    #ifndef NO_PIXEL_SNAP
                    offset.x = (floor(offset.x * _MainTex_TexelSize.z) + 0.5) / _MainTex_TexelSize.z;
                    offset.y = (floor(offset.y * _MainTex_TexelSize.w) + 0.5) / _MainTex_TexelSize.w;
                    #endif

                    half4 col = (tex2D(_MainTex, offset) + _TextureSampleAdd) * IN.color;

                    #ifdef UNITY_UI_CLIP_RECT
                    col.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                    #endif

                    #ifdef UNITY_UI_ALPHACLIP
                    clip(col.a - 0.001);
                    #endif

                    #if defined(NO_WRAP) || !defined(CROP)
                    col.a = (offset.x < 0 || offset.x > 1) ? 0 : col.a;
                    #endif

                    return col;
                }
            ENDCG
            }
        }
}