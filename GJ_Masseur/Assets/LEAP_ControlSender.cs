using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LEAP_ControlSender : MonoBehaviour
{


    public GameObject RHand;
    public GameObject LHand;

    public Vector3 Value;
    [Range(1f, 30f)]
    public float PosMultiplier;
    [Range(0f, 10f)]
    public float RotMultiplier;
    [Range(1f, 20f)]
    public float ScaleMultiplier;

    public Vector2 X_MinMaxValue;
    public Vector2 Y_MinMaxValue;

    private Vector3 Position;
    private float Scale;
    private Vector3 Rotation;

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
        //Scale = 7* RHand.transform.position.z * ScaleMultiplier;
        Scale = map(RHand.transform.position.z, 0.3f, -0.3f, 0.2f, 5);

        OBJ.transform.position = new Vector3(Position.x, Position.y, OBJ.transform.position.z);
        OBJ.transform.eulerAngles = new Vector3(OBJ.transform.rotation.eulerAngles.x, OBJ.transform.rotation.eulerAngles.y, -Rotation.z);
        OBJ.transform.localScale = new Vector3(Scale, Scale, OBJ.transform.localScale.z);

        Scale = map(RHand.transform.position.z, -0.3f, 0.3f, 0.2f, 5);

        //Scale = map(RHand.transform.position.z, -0.3, 0.3, 3, 12);
        //NormalizedValue.y = map(Value.y, Y_MinMaxValue.x, Y_MinMaxValue.y, 0, 1);

    }
}
