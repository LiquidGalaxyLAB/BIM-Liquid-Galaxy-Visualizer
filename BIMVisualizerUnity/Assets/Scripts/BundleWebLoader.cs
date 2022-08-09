using UnityEngine;
using UnityEngine.Networking;
using System.Collections;

public class BundleWebLoader : MonoBehaviour
{
    void Start()
    {
        StartCoroutine(GetAssetBundle());
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
            obj.tag = "Selectable";
            bundle.Unload(false);
        }
    }
}