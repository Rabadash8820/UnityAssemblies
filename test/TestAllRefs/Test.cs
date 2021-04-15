#if v20193
#define NEWTONSOFT_JSON_AVAILABLE
#endif
#if v20194
#define NEWTONSOFT_JSON_AVAILABLE
#endif
#if v20201
#define NEWTONSOFT_JSON_AVAILABLE
#endif
#if v20202
#define NEWTONSOFT_JSON_AVAILABLE
#endif
#if v20203
#define NEWTONSOFT_JSON_AVAILABLE
#endif
#if v20211
#define NEWTONSOFT_JSON_AVAILABLE
#endif

#if v20192
#define NUNIT_AVAILABLE
#endif
#if v20193
#define NUNIT_AVAILABLE
#endif
#if v20194
#define NUNIT_AVAILABLE
#endif
#if v20201
#define NUNIT_AVAILABLE
#endif
#if v20202
#define NUNIT_AVAILABLE
#endif
#if v20203
#define NUNIT_AVAILABLE
#endif
#if v20211
#define NUNIT_AVAILABLE
#endif

#if v20192
#define MOQ_AVAILABLE
#endif
#if v20193
#define MOQ_AVAILABLE
#endif

#if v20192
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif
#if v20193
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif
#if v20194
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif
#if v20201
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif
#if v20202
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif
#if v20203
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif
#if v20211
#define UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
#endif

#if v20211
#define UNITYENGINE_DEVICE_AVAILABLE
#endif

namespace Unity3D.Test {
    public class TestBehaviour : UnityEngine.MonoBehaviour {
        public UnityEngine.UI.Text TextField;
        public UnityEngine.TestTools.TestPlatform TestPlatformField;
        public UnityEditor.Android.AndroidPlatformIconKind AndroidPlatformIconKind;
        public UnityEditor.iOS.Extensions.Common.AppleCommandLineBuildAndRunException CommandLineBuildAndRunException;
        public UnityEditor.iOS.Xcode.PlistDocument PlistDocument;
#if NEWTONSOFT_JSON_AVAILABLE
        public Newtonsoft.Json.JsonConverter JsonConverterField;
#endif
#if UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
        public UnityEngine.Analytics.ContinuousEvent ContinuousEventField;
#endif
#if UNITYENGINE_DEVICE_AVAILABLE
        public int ScreenHeight = UnityEngine.Device.Screen.height;
#endif

    }

    public class TestEditor : UnityEditor.Editor { }

#if NUNIT_AVAILABLE
    [NUnit.Framework.TestFixture]
#endif
    public class TestFixture {
#if MOQ_AVAILABLE
        public Moq.Mock<TestBehaviour> Mock;
#endif
    }
}
