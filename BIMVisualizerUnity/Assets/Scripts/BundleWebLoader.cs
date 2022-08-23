using UnityEngine;
using UnityEngine.Networking;
using System.Collections;
using System;
using System.Text;
using System.Linq;
using UnityEngine.UI;
using RuntimeGizmos;
using Newtonsoft.Json;

public static class ButtonExtension
{
    public static void AddEventListener<T>(this Button button, T param, Action<T> OnClick)
    {
        button.onClick.AddListener(delegate ()
        {
            OnClick(param);
        });
    }
}

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
    Button moveTool, rotateTool, scaleTool;

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

    [Serializable]
    public class Meta
    {
        public int elementID { get; set; }
        public string family { get; set; }
        public string type { get; set; }
        public int? length { get; set; }
        public string baseLevel { get; set; }
        public string baseOffset { get; set; }
        public string topLevel { get; set; }
        public int? topOffset { get; set; }
    }

    [Serializable]
    public class BIM
    {
        public Meta[] meta;
    }

    [Serializable]
    public class Body
    {
        public BIM[] values;
    }

    public Meta[] metas;
    private ProjectionPlane projectionPlane;

    private void Awake()
    {
        networkManager = GameObject.Find("Network Manager").GetComponent<NetworkManager>();
        transformGizmo = GameObject.Find("ControllerCamera").GetComponent<TransformGizmo>();
        projectionPlane = GameObject.Find("ProjectionPlane").GetComponent<ProjectionPlane>();

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
                    } else if (code.Equals("masterIdx"))
                    {
                        int idx = (int)networkManager.ParseMessage(data);
                        SetMeta(idx);
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

    private void SetMeta(int idx)
    {
        GameObject canvas = GameObject.Find("Canvas2");
        if (canvas != null)
        {
            Text txt = canvas.transform.Find("Meta").GetComponentInChildren<Text>();
            txt.text = "Metadata\n\n";
            txt.text += "Element ID: " + metas[idx].elementID.ToString();
            txt.text += "\nFamily: " + metas[idx].family;
            txt.text += "\nType: " + metas[idx].type;
            txt.text += "\nLenght: " + metas[idx].length;
            txt.text += "\nBase Level: " + metas[idx].baseLevel;
            txt.text += "\nBase Offset: " + metas[idx].baseOffset;
            txt.text += "\nTop Level: " + metas[idx].topLevel;
            txt.text += "\nTop Offset: " + metas[idx].topOffset;
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
            obj.name = "Model";

            obj.transform.localScale = new Vector3(0.5f, 0.5f, 0.5f);

            originalPosition = obj.transform.position;
            originalRotation = obj.transform.rotation;
            originalScale = obj.transform.localScale;

            model = obj;

            bundle.Unload(false);

            StartCoroutine(GetAllData());
        }
    }

    IEnumerator GetAllData()
    {
        using (UnityWebRequest request = UnityWebRequest.Get("https://bimlgvisualizer-server.loca.lt/bim"))
        {
            yield return request.SendWebRequest();

            if (request.result == UnityWebRequest.Result.ConnectionError)
            {
                Debug.Log("Error on get data: " + request.error);
            }
            else
            {
                string json = request.downloadHandler.text;
                Body body = JsonConvert.DeserializeObject<Body>(json);

                Transform[] t = GameObject.Find("Model").GetComponentsInChildren<Transform>();

                for (int i = 0; i < body.values.Length; i++)
                {
                    if (body.values[i].meta != null)
                    {
                        for (int j = 0; j < body.values[i].meta.Length; j++)
                        {
                            for (int k = 0; k < t.Length; k++)
                            {
                                if (t[k].name.Contains(body.values[i].meta[j].elementID.ToString()))
                                {
                                    metas = body.values[i].meta;
                                    break;
                                }
                            }
                        }
                    }
                }

                if (networkManager.isMaster)
                {
                    GameObject panel = GameObject.Find("Sidebar").transform.Find("Panel").gameObject;
                    if (metas.Length > 0)
                    {
                        GameObject btn = panel.transform.GetChild(0).gameObject;
                        GameObject g;

                        for (int i = 0; i < metas.Length; i++)
                        {
                            g = Instantiate(btn, panel.transform);
                            g.transform.GetChild(0).GetComponent<Text>().text = metas[i].elementID.ToString();
                            g.GetComponent<Button>().AddEventListener(i, ItemClicked);
                        }

                        Destroy(btn);
                    } else
                    {
                        GameObject.Find("Sidebar").SetActive(false);
                        GameObject.Find("SidebarText").SetActive(false);
                    }
                }
            }
        }
    }

    async private void ItemClicked(int itemIndex)
    {
        await networkManager.Send("masterIdx", itemIndex);
    }

    private void Reset()
    {
        model.transform.position = originalPosition;
        model.transform.rotation = originalRotation;
        model.transform.localScale = originalScale;
    }
}
