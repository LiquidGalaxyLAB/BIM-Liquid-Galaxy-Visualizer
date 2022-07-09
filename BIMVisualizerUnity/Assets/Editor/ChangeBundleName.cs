using System.IO;
using UnityEditor;
using UnityEngine;

public class ChangeBundleName : MonoBehaviour
{
    [MenuItem("Assets/Change Bundle Name")]
    static void Change()
    {
        string[] files = Directory.GetFiles("Assets/Models", "*.fbx", SearchOption.TopDirectoryOnly);
        AssetImporter.GetAtPath(files[0]).SetAssetBundleNameAndVariant("demo", "");

    }
}