using UnityEngine;
using System.Collections;
using Windows.Kinect;
public class detec : MonoBehaviour
{
    public ComputeShader compute_shader;
    RenderTexture A;
    RenderTexture B;
    //public Texture C;
    public GameObject decor;
    public GameObject img1;
    public GameObject img2;
    public GameObject img3;

    public Material material;
    int handle_main;
    [Range(0, 1)]
    public float _img1;
    [Range(0, 1)]
    public float _img2;
    [Range(0, 1)]
    public float _img3;
    [Range(0, 1)]
    public float _s1;
    [Range(0, 1)]
    public float _s2;
    [Range(0, 1)]
    public float _s3;
    [Range(0, 1)]
    public float _s4;
    [Range(0, 1)]
    public float _s5;
    [Range(0, 1)]
    public float _s6;
    [Range(0, 1)]
    public float _rx1;
    [Range(0, 1)]
    public float _rx2;
    [Range(0, 1)]
    public float _ry1;
    [Range(0, 1)]
    public float _ry2;
    [Range(0, 1)]
    public float _blur;
    public GameObject DepthSourceManager;
    private KinectSensor _Sensor;
    private CoordinateMapper _Mapper;
    Texture2D texture;
    //public Material mat;
    byte[] depthBitmapBuffer;
    public float deb = 1.0f;
    public float scale = 1.0f;
    private const int _DownsampleSize = 4;
    private const double _DepthScale = 0.1f;
    private const int _Speed = 50;
    private DepthSourceManager _DepthManager;
    void Start()
    {
        _Sensor = KinectSensor.GetDefault();
        if (_Sensor != null)
        {
            _Mapper = _Sensor.CoordinateMapper;
            var frameDesc = _Sensor.DepthFrameSource.FrameDescription;
            depthBitmapBuffer = new byte[frameDesc.LengthInPixels * 3];
            texture = new Texture2D(frameDesc.Width, frameDesc.Height, TextureFormat.RGB24, false);
            if (!_Sensor.IsOpen)
            {
                _Sensor.Open();
            }
        }
        A = new RenderTexture(1024, 1024, 0);
        A.enableRandomWrite = true;
        A.Create();
        B = new RenderTexture(1024,  1024, 0);
        B.enableRandomWrite = true;
        B.Create();
        
        /*C = new RenderTexture(512, 424, 0);
        C.enableRandomWrite = true;
        C.Create();     */
        handle_main = compute_shader.FindKernel("CSMain");    

    }
    void OnGUI()
    {
        GUI.BeginGroup(new Rect(0, 0, Screen.width, Screen.height));
        GUI.EndGroup();
    }
    void Update()
    {
        if (_Sensor == null)
        {
            return;
        }

        if (DepthSourceManager == null)
        {
            return;
        }

        _DepthManager = DepthSourceManager.GetComponent<DepthSourceManager>();
        if (_DepthManager == null)
        {
            return;
        }

        updateTexture();
        compute_shader.SetTexture(handle_main, "reader", A);
        compute_shader.SetTexture(handle_main, "reader2", texture);
        compute_shader.SetFloat("_time", Time.time);
        compute_shader.SetFloat("_img1", _img1);
        compute_shader.SetFloat("_img2", _img2);
        compute_shader.SetFloat("_img3", _img3);
        compute_shader.SetFloat("_s1", _s1);
        compute_shader.SetFloat("_s2", _s2);
        compute_shader.SetFloat("_s3", _s3);
        compute_shader.SetFloat("_s4", _s4);
        compute_shader.SetFloat("_s5", _s5);
        compute_shader.SetFloat("_s6", _s6);
        compute_shader.SetFloat("_rx1", _rx1);
        compute_shader.SetFloat("_rx2", _rx2);
        compute_shader.SetFloat("_ry1", _ry1);
        compute_shader.SetFloat("_ry2", _ry2);
        compute_shader.SetFloat("_blur", _blur);
        compute_shader.SetTexture(handle_main, "writer", B);
        compute_shader.Dispatch(handle_main, B.width / 8, B.height / 8, 1);
        compute_shader.SetTexture(handle_main, "reader", B);
        compute_shader.SetTexture(handle_main, "writer", A);
        compute_shader.Dispatch(handle_main, B.width / 8, B.height / 8, 1);
        material.SetTexture("_MainTex", B);
        img1.GetComponent<Renderer>().material.mainTexture = B;
        img2.GetComponent<Renderer>().material.mainTexture = B;
        img3.GetComponent<Renderer>().material.mainTexture = B;     
        decor.GetComponent<Renderer>().material.SetTexture("_sec", texture);
    }
    void updateTexture()
    {
        // get new depth data from DepthSourceManager.
        ushort[] rawdata = _DepthManager.GetData();

        // convert to byte data (
        for (int i = 0; i < rawdata.Length; i++)
        {

            byte value = (byte)(rawdata[i] * scale + deb);
            // byte value2 = (byte)255;
            if (value < 0.05f) { value = 0; value = 255; }
            int colorindex = i * 3;
            depthBitmapBuffer[colorindex + 0] = value;
            depthBitmapBuffer[colorindex + 1] = value;
            depthBitmapBuffer[colorindex + 2] = value;
        }
        // make texture from byte array
        texture.LoadRawTextureData(depthBitmapBuffer);
        texture.Apply();
    }
    void OnApplicationQuit()
    {
        if (_Mapper != null)
        {
            _Mapper = null;
        }

        if (_Sensor != null)
        {
            if (_Sensor.IsOpen)
            {
                _Sensor.Close();
            }

            _Sensor = null;
        }
    }
}
