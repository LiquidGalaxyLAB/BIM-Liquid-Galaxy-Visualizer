using UnityEngine;
using UnityEngine.Networking;
using System.Collections;
using System;
using System.Text;
using System.Linq;

public class BundleWebLoader : MonoBehaviour
{
    GameObject model;
    Vector3 oldEulerAngles = Vector3.zero;
    private NetworkManager networkManager;

    [Serializable]
    public class Rotation
    {
        public float rX { get; set; }
        public float rY { get; set; }
        public float rZ { get; set; }
    }

    private void Awake()
    {
        networkManager = GameObject.Find("Network Manager").GetComponent<NetworkManager>();
    }

    void Start()
    {
        StartCoroutine(GetAssetBundle());

        networkManager.websocket.OnMessage += (bytes) =>
        {
            if (!networkManager.isMaster)
            {
                string code = Encoding.UTF8.GetString(bytes, 0, 9);
                if (code.Equals("masterRot"))
                {
                    int dataLength = bytes.Length - 9;
                    byte[] data = new byte[dataLength];
                    data = bytes.Skip(9).Take(dataLength).ToArray();
                    Rotation rotation = (Rotation)networkManager.ParseMessage(data);

                    model.transform.eulerAngles = new Vector3(rotation.rX, rotation.rY, rotation.rZ);
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
        }
    }

    IEnumerator GetAssetBundle()
    {
        UnityWebRequest www = UnityWebRequestAssetBundle.GetAssetBundle("http://172.16.65.29:3210/tmp/current");
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
            obj.name = "Model";
            obj.tag = "Selectable";

            model = obj;
            oldEulerAngles = model.transform.rotation.eulerAngles;

            bundle.Unload(false);
        }
    }
}