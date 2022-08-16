using UnityEngine;
using UnityEditor;
using System.IO;

public class CreateAssetBundles
{
    [MenuItem("Assets/Build AssetBundles")]
    static void BuildAllAssetBundles()
    {
        // clean previous data
        if (Directory.Exists("Assets/AssetBundles")) {
            Directory.Delete("Assets/AssetBundles", true);
        }

        // find the model and tag it as an asset bundle
        string[] files = Directory.GetFiles("Assets/Models", "*.fbx", SearchOption.TopDirectoryOnly);
        string filename = Path.GetFileNameWithoutExtension(files[0]);
        AssetImporter.GetAtPath(files[0]).SetAssetBundleNameAndVariant(filename, "");

        // generate the asset bundle of the tagged model
        string assetBundleDirectory = "Assets/AssetBundles";
        if (!Directory.Exists(Application.streamingAssetsPath))
        {
            Directory.CreateDirectory(assetBundleDirectory);
        }
        BuildPipeline.BuildAssetBundles(assetBundleDirectory, BuildAssetBundleOptions.ChunkBasedCompression, BuildTarget.WebGL);
        AssetDatabase.Refresh();

        // move the asset bundle to public/models dir on server
        string oldPath = "Assets/AssetBundles/" + filename;
        string newPath = "public/models/" + filename;
        File.Move(oldPath, newPath);

        // clean data
        Directory.Delete("Assets/Models", true);
    }
}