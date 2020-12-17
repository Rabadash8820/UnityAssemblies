#!/bin/bash

bumpVersions() {
    newVersion=
    prompt="Enter the new version (such as '1.0.0-rc1'): "
    read -p "$prompt" newVersion
    while [ -z "$newVersion" ] ; do
        echo "Version string cannot be empty."
        read -p "$prompt" newVersion
    done

    echo ""
    echo "Update version string to '$newVersion' in the following places:"
    echo "    Sample project file in packaged readme.txt"
    echo "    Sample project file at top of main README"
    echo "    <version/> element of nuspec"
    echo "Also update Unity version strings to the latest version in the following places:"
    echo "    Sample project file in packaged readme.txt"
    echo "    Sample project file snippets in main README"
    echo ""
    read -p "Press [Enter] when you're done..."
}

verifyReleaseNotes() {
    echo ""
    echo "Verify that the <releaseNotes/> element of nuspec is up-to-date"
    echo ""
    read -p "Press [Enter] when you're done..."
}

checkForNuGet() {
    nuget help &> /dev/null
    if [ $? != 127 ] ; then
        return 1
    else
        echo "nuget.exe not found on PATH. Checking current directory..."
        ./nuget.exe help &> /dev/null
        if [ $? != 127 ] ; then
            return 2
        else
            echo "nuget.exe not found in current directory. Cannot continue."
            return 3
        fi
    fi
}

nugetPack() {
    echo ""
    echo "Creating NuGet package..."
    $nugetPath pack "$cwd/nupkg/Unity3D.nuspec"
    return $?
}

nugetSign() {
    defaultTimestamper="http://timestamp.digicert.com"
    echo ""
    read -p "Enter the URL of an RFC 3161 timestamp server (or hit [ENTER] to use '$defaultTimestamper'): " timestamper
    if [ -z "$timestamper" ]; then timestamper=$defaultTimestamper; fi

    certPrompt="Enter the file path to the certificate to be used while signing the package (probably a .p12 or .pfx file): "
    read -p "$certPrompt" certPath
    while [ -z "$certPath" ] ; do
        echo "Certificate path cannot be empty."
        read -p "$certPrompt" certPath
    done
    
    echo ""
    echo "Signing NuGet package..."
    "$nugetPath" sign "$nupkgPath" -Timestamper "$timestamper" -CertificatePath "$certPath"
    return $?
}

nugetPush() {
    read derp  # This hacky piece of sh*t is just here to catch an [Enter], that I have no idea where is coming from...

    defaultNuGetSource="nuget.org"
    echo ""
    read -p "Enter the URL of the NuGet source (or hit [Enter] to use '$defaultNuGetSource'): " nugetSource
    if [ -z $nugetSource ]; then nugetSource=$defaultNuGetSource; fi

    keyPrompt="Enter the API key for the NuGet source: "
    read -p "$keyPrompt" sourceApiKey
    while [ -z "$sourceApiKey" ] ; do
        echo "API key cannot be empty."
        read -p "$keyPrompt" sourceApiKey
    done

    echo ""
    echo "Publishing NuGet package to nuget.org..."
    "$nugetPath" push "$nupkgPath" -Source "$nugetSource" -ApiKey "$sourceApiKey"
    errNum=$?
    if [ $errNum != 0 ]; then return $errNum; fi

    if [ "$nugetSource" = "nuget.org" ] ; then
        echo ""
        echo "Now sign in to nuget.org, and copy over the documentation from the previous package version"
        echo "    This should basically be the contents of the packaged readme.txt file"
        echo "    Also be sure to increment the UnityVersion and PackageReference version strings therein!"
        echo ""
        read -p "Press [Enter] when you're done..."
    fi
}

main() {
    cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    # Make sure user has updated package info
    bumpVersions && verifyReleaseNotes

    # Get the path to nuget.exe
    checkForNuGet
    nugetCode=$?
    nugetPath=nuget
    if [ "$nugetCode" = "3" ] ; then
        return 1
    elif [ "$nugetCode" = "2" ] ; then
        nugetPath="./nuget.exe"
    fi

    # Create the NuGet package
    nugetPack
    if [ $? != 0 ]; then return 1; fi
    nupkgPath="$cwd/Unity3D.$newVersion.nupkg"

    # Sign and push the NuGet package
    nugetSign && nugetPush
    errNum=$?

    echo ""
    if [ $errNum = 0 ] ; then
        echo "Publish complete!"
    else
        echo "Publish completed with error code: $errNum"
    fi
}

main $@
