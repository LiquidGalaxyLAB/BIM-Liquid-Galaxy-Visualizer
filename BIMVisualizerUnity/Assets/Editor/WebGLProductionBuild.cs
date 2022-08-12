using UnityEditor;
using UnityEngine;

public class WebGLProductionBuild : MonoBehaviour
{
    [MenuItem("Assets/Build WebGL")]
    static void Build()
    {
        string[] scenes = { "Assets/Scenes/SampleScene.unity" };
        BuildPipeline.BuildPlayer(scenes, "/Home/lg/client", BuildTarget.WebGL, BuildOptions.None);
    }
}
