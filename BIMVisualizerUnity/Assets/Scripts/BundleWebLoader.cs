using UnityEngine;
using UnityEngine.Networking;
using System.Collections;
using System;
using System.Text;
using System.Linq;
using UnityEngine.UI;
using RuntimeGizmos;

public class BundleWebLoader : MonoBehaviour
{
    private GameObject model;
    private Vector3 oldEulerAngles = Vector3.zero;
    private Vector3 oldPosition = Vector3.zero;
    private Vector3 oldScale = Vector3.zero;
    private Vector3 originalPosition;
    private Quaternion originalRotation;
    private Vector3 originalScale = Vector3.zero;
    private NetworkManager networkManager;
    private TransformGizmo transformGizmo;
    Button moveTool, rotateTool, scaleTool, resetTool;

    private int MASTER_MOV_LENGTH = 9;

    [Serializable]
    public class Rotation
    {
        public float rX { get; set; }
        public float rY { get; set; }
        public float rZ { get; set; }
    }

    [Serializable]
    public class Movement
    {
        public float pX { get; set; }
        public float pY { get; set; }
        public float pZ { get; set; }
    }

    [Serializable]
    public class Scale
    {
        public float sX { get; set; }
        public float sY { get; set; }
        public float sZ { get; set; }
    }

    private void Awake()
    {
        resetTool = GameObject.Find("ResetTool").GetComponent<Button>();
        networkManager = GameObject.Find("Network Manager").GetComponent<NetworkManager>();
        transformGizmo = GameObject.Find("ControllerCamera").GetComponent<TransformGizmo>();

        moveTool = GameObject.Find("MoveTool").GetComponent<Button>();
        rotateTool = GameObject.Find("RotateTool").GetComponent<Button>();
        scaleTool = GameObject.Find("ScaleTool").GetComponent<Button>();
    }

    void Start()
    {
        StartCoroutine(GetAssetBundle());
        
        networkManager.websocket.OnMessage += (bytes) =>
        {
            if (!networkManager.isMaster)
            {
                if (bytes.Length > MASTER_MOV_LENGTH)
                {
                    string code = Encoding.UTF8.GetString(bytes, 0, MASTER_MOV_LENGTH);
                    int dataLength = bytes.Length - MASTER_MOV_LENGTH;
                    byte[] data = new byte[dataLength];
                    data = bytes.Skip(MASTER_MOV_LENGTH).Take(dataLength).ToArray();

                    if (code.Equals("masterRot"))
                    {
                        Rotation rotation = (Rotation)networkManager.ParseMessage(data);
                        model.transform.eulerAngles = new Vector3(rotation.rX, rotation.rY, rotation.rZ);
                    } else if (code.Equals("masterMov"))
                    {
                        Movement movement = (Movement)networkManager.ParseMessage(data);
                        model.transform.position = new Vector3(movement.pX, movement.pY, movement.pZ);
                    } else if (code.Equals("masterScl"))
                    {
                        Scale scale = (Scale)networkManager.ParseMessage(data);
                        model.transform.localScale = new Vector3(scale.sX, scale.sY, scale.sZ);
                    }
                }
            }
        };
    }

    async private void FixedUpdate()
    {
        if (networkManager.isMaster)
        {
            if (oldEulerAngles != model.transform.rotation.eulerAngles)
            {
                oldEulerAngles = model.transform.rotation.eulerAngles;

                Rotation rotation = new Rotation()
                {
                    rX = model.transform.eulerAngles.x,
                    rY = model.transform.eulerAngles.y,
                    rZ = model.transform.eulerAngles.z
                };

                await networkManager.Send("masterRot", rotation);
            }
            else if (oldPosition != model.transform.position)
            {
                oldPosition = model.transform.position;

                Movement movement = new Movement()
                {
                    pX = model.transform.position.x,
                    pY = model.transform.position.y,
                    pZ = model.transform.position.z
                };

                await networkManager.Send("masterMov", movement);
            }
            else if (oldScale != model.transform.localScale)
            {
                oldScale = model.transform.localScale;

                Scale scale = new Scale()
                {
                    sX = model.transform.localScale.x,
                    sY = model.transform.localScale.y,
                    sZ = model.transform.localScale.z
                };

                await networkManager.Send("masterScl", scale);
            }
        }
    }

    private void Clear()
    {
        moveTool.image.color = new Color32(255, 255, 255, 255);
        rotateTool.image.color = new Color32(255, 255, 255, 255);
        scaleTool.image.color = new Color32(255, 255, 255, 255);
    }

    public void ResetBtnOnPressed()
    {
        transformGizmo.ClearTargets();
        
        Reset();
        Clear();
    }

    public void MoveBtnOnPressed()
    {
        Clear();
        moveTool.image.color = new Color32(200, 200, 200, 128);

        transformGizmo.transformType = TransformType.Move;
        transformGizmo.AddTarget(model.transform, false);
    }

    public void RotateBtnOnPressed()
    {
        Clear();
        rotateTool.image.color = new Color32(200, 200, 200, 128);

        transformGizmo.transformType = TransformType.Rotate;
        transformGizmo.AddTarget(model.transform, false);
    }

    public void ScaleBtnOnPressed()
    {
        Clear();
        scaleTool.image.color = new Color32(200, 200, 200, 128);

        transformGizmo.transformType = TransformType.Scale;
        transformGizmo.AddTarget(model.transform, false);
    }

    IEnumerator GetAssetBundle()
    {
        UnityWebRequest www = UnityWebRequestAssetBundle.GetAssetBundle("https://bimlgvisualizer-server.loca.lt/tmp/current");
        yield return www.SendWebRequest();

        if (www.result != UnityWebRequest.Result.Success)
        {
            Debug.Log(www.error);
        }
        else
        {
            AssetBundle bundle = DownloadHandlerAssetBundle.GetContent(www);
            string rootAssetPath = bundle.GetAllAssetNames()[0];
            GameObject obj = Instantiate(bundle.LoadAsset<GameObject>(rootAssetPath));
            obj.tag = "Selectable";

            originalPosition = obj.transform.position;
            originalRotation = obj.transform.rotation;
            originalScale = obj.transform.localScale;

            model = obj;

            bundle.Unload(false);
        }
    }

    private void Reset()
    {
        model.transform.position = originalPosition;
        model.transform.rotation = originalRotation;
        model.transform.localScale = originalScale;
    }
}
