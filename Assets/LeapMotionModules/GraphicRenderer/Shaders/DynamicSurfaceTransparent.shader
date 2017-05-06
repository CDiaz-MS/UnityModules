﻿Shader "LeapMotion/GraphicRenderer/Surface/Dynamic Transparent" {
  Properties {
    _Color("Color", Color) = (1,1,1,1)
    _MainTex ("Albedo (RGB)", 2D) = "white" {}
  }
  SubShader {
    Tags { "Queue"="Transparent" "RenderType"="Transparent" }
    LOD 200

    Cull Back
    ZWrite Off
    
    CGPROGRAM
    #pragma surface surf Standard alpha:auto fullforwardshadows vertex:vert addshadow 
    #pragma target 3.0
    
    #define GRAPHIC_RENDERER_VERTEX_NORMALS //surface shaders always need normals
    #define GRAPHIC_RENDERER_VERTEX_UV_0    //surface shaders always need uv0

  //#pragma shader_feature _ GRAPHIC_RENDERER_CYLINDRICAL GRAPHIC_RENDERER_SPHERICAL
  //#pragma shader_feature _ GRAPHIC_RENDERER_VERTEX_UV_1
  //#pragma shader_feature _ GRAPHIC_RENDERER_VERTEX_UV_2
  //#pragma shader_feature _ GRAPHIC_RENDERER_VERTEX_COLORS
  //#pragma shader_feature _ GRAPHIC_RENDERER_MOVEMENT_TRANSLATION GRAPHIC_RENDERER_MOVEMENT_FULL
  //#pragma shader_feature _ GRAPHIC_RENDERER_TINTING
  //#pragma shader_feature _ GRAPHIC_RENDERER_BLEND_SHAPES
    
    #include "Assets/LeapMotionModules/GraphicRenderer/Resources/BakedRenderer.cginc"
    #include "UnityCG.cginc"

    struct Input {
      SURF_INPUT_GRAPHICAL
      float2 uv_MainTex;
    };

    sampler2D _MainTex;

    void vert(inout appdata_graphic_baked v, out Input o) {
      UNITY_INITIALIZE_OUTPUT(Input, o);
      BEGIN_V2F(v);
      APPLY_BAKED_GRAPHICS_STANDARD(v, o);   
    }

    void surf (Input IN, inout SurfaceOutputStandard o) {
      fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
#ifdef GRAPHICS_HAVE_COLOR
      color *= IN.color;
#endif

      o.Albedo = color.rgb;
    o.Alpha = color.a;
    }
    ENDCG
  }
  FallBack "Diffuse"
}
