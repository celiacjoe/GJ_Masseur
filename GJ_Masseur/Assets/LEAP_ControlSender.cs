using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LEAP_ControlSender : MonoBehaviour
{

    public GameObject RHand;
    public GameObject LHand;

    public Vector3 Value;
    [Range(1f, 5f)]
    public float PosMultiplier;
    [Range(0.0f, 3f)]
    public float RotMultiplier;
    [Range(1f, 3f)]
    public float ScaleMultiplier;

    public Vector2 X_MinMaxValue;
    public Vector2 Y_MinMaxValue;

    private Vector3 Position;
    private float Scale;
    private Vector3 Rotation;
    // public float X_MinValue;
    // public float X_MaxValue;
    //public float Y_MinValue;
    // public float Y_MaxValue;

    public GameObject OBJ;

    // Fonction custo
    float map(float Val, float minInit, float MaxInit, float MinFinal, float MaxFinal)
    {
        return MinFinal + (Val - minInit) * (MaxFinal - MinFinal) / (MaxInit - minInit);
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        Position = RHand.transform.position * PosMultiplier;
        Rotation = RHand.transform.rotation.eulerAngles * RotMultiplier;
        Scale = RHand.transform.position.z * ScaleMultiplier;

        OBJ.transform.position = new Vector3(Position.x, Position.y, OBJ.transform.position.z);
        //RHand.transform.rotation.eulerAngles
        OBJ.transform.eulerAngles = new Vector3(OBJ.transform.rotation.eulerAngles.x, OBJ.transform.rotation.eulerAngles.y, -Rotation.z);
      //  OBJ.transform.localEulerAngles = new Vector3(OBJ.transform.rotation.eulerAngles.x, OBJ.transform.rotation.eulerAngles.y, -Rotation.z);
        OBJ.transform.localScale = new Vector3(Scale, Scale, OBJ.transform.localScale.z);

        //Position = map(Value.x, -X_MinMaxValue.x, X_MinMaxValue.x, -2, 2);
        //NormalizedValue.y = map(Value.y, Y_MinMaxValue.x, Y_MinMaxValue.y, 0, 1);

    }
}
