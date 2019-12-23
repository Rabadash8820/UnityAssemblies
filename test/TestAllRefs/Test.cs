namespace Unity3D.Test {
    public class TestBehaviour : UnityEngine.MonoBehaviour {
        public UnityEngine.UI.Text TextField;
        public UnityEngine.TestTools.TestPlatform TestPlatformField;
    }

    public class TestEditor : UnityEditor.Editor { }

#if v20192
    [NUnit.Framework.TestFixture]
#endif
    public class TestFixture { }
}
