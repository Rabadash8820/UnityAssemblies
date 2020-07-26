#if v20192
#define NUNIT_AVAILABLE
#endif
#if v20193
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


namespace Unity3D.Test {
    public class TestBehaviour : UnityEngine.MonoBehaviour {
        public UnityEngine.UI.Text TextField;
        public UnityEngine.TestTools.TestPlatform TestPlatformField;
#if UNITY_ANALYTICS_STANDARD_EVENTS_AVAILABLE
        public UnityEngine.Analytics.ContinuousEvent ContinuousEventField;
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
