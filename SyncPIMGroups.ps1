# ----------------------------------
#
# Desc: Synchronize an Active Directory Group to Azure AD PIM group
#
# V1.0
#
# -----------------------------------

# Init param
param(

    $ADGroupName,
    $AzureADGroupName

)


#Connect to Azure AD

Connect-AzureAD 

#Checking if exist

$groupADExists = Get-ADGroup -Identity $ADGroupName
$groupAADexists = Get-AzureADGroup -SearchString $AzureADGroupName

if ($groupADExists -eq ""){

    write-host "The group $groupADExists does not exist!" -ForegroundColor DarkRed
    exit

}
elseif ($groupAADExists -eq "")
{

    write-host "The group $groupAADExists does not exist!" -ForegroundColor DarkRed
    exit
}


#Get member of AD Group

$members = Get-ADGroupMember -Identity $ADGroupName

Foreach ($member in $members){

    #Check AAD if user exists
    
    $result = Get-AzureADUser -SearchString $member.SamAccountName

    If ($result -eq ""){
    
        $msg = "User " + $member.DisplayName + " does not exist in Azure AD!"
        Write-Host $msg -ForegroundColor DarkRed
        
    }
    else
    {
    
        #Write the user into Azure AD Group

        Add-AzureADGroupMember -ObjectId $groupAADexists.ObjectID -RefObjectId  $result.ObjectID
    
    
    
    }



}

