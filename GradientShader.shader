Shader "Unlit/GradientShader" {
    Properties { //input data
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
    }
    SubShader {
        Tags { "RenderType"="Opaque" }

        Pass {
            CGPROGRAM    //shader code
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            //filled by unity
            struct MeshData { //Per vertex mesh data
                float4 vertex : POSITION; //vertex position
                float2 uv0 : TEXCOORD0;    //uv coordinates 
                float3 normals : NORMAL;
            };

            struct v2f {
                float4 vertex : SV_POSITION; //clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            v2f vert (MeshData v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = v.normals;
                o.uv = v.uv0;
                return o;
            }

            float InverseLerp (float a, float b, float v) {
                return (v-a) / (b-a);
            }

            fixed4 frag (v2f i) : SV_Target {
                float t = saturate ( InverseLerp(_ColorStart, _ColorEnd, i.uv.x) ); //saturate means clamp between 0 and 1.
                float4 outColor = lerp(_ColorA, _ColorB, t);
                return outColor;
            }
            ENDCG
        }
    }
}
