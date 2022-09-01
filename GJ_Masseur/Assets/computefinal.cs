using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class computefinal : MonoBehaviour
{
    public ComputeShader compute_shader;
    RenderTexture A;
    RenderTexture B;
    public Texture E;
    public Material material;
    [Range(0, 1)]
    public float _s1;
    [Range(0, 1)]
    public float _s2;
    [Range(0, 1)]
    public float _s3;
    [Range(0, 1)]
    public float _s4;
    int handle_main;
    void Start()
    {
        A = new RenderTexture(1920, 1080, 0);
        A.enableRandomWrite = true;
        A.Create();
        B = new RenderTexture(1920, 1080, 0);
        B.enableRandomWrite = true;
        B.Create();
        handle_main = compute_shader.FindKernel("CSMain");
    }

    // Update is called once per frame
    void Update()
    {
        compute_shader.SetTexture(handle_main, "reader", A);
        compute_shader.SetTexture(handle_main, "reader2", E);
        compute_shader.SetFloat("_s1", _s1);
        compute_shader.SetFloat("_s2", _s2);
        compute_shader.SetFloat("_s3", _s3);
        compute_shader.SetFloat("_s4", _s4);
        compute_shader.SetTexture(handle_main, "writer", B);

        compute_shader.Dispatch(handle_main, B.width / 8, B.height / 8, 1);
        compute_shader.SetTexture(handle_main, "reader", B);
        compute_shader.SetTexture(handle_main, "writer", A);

        compute_shader.Dispatch(handle_main, B.width / 8, B.height / 8, 1);

        material.SetTexture("_img", B);

    }
}
