﻿<#
.SYNOPSIS
	Displays a graphical console to browse the help for the App Deployment Toolkit functions
    # LICENSE #
    PowerShell App Deployment Toolkit - Provides a set of functions to perform common application deployment tasks on Windows.
    Copyright (C) 2017 - Sean Lillis, Dan Cunningham, Muhammad Mashwani, Aman Motazedian.
    This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
.DESCRIPTION
	Displays a graphical console to browse the help for the App Deployment Toolkit functions
.EXAMPLE
	AppDeployToolkitHelp.ps1
.NOTES
.LINK
	http://psappdeploytoolkit.com
#>

##*===============================================
##* VARIABLE DECLARATION
##*===============================================

## Variables: Script
[string]$appDeployToolkitHelpName = 'PSAppDeployToolkitHelp'
[string]$appDeployHelpScriptFriendlyName = 'App Deploy Toolkit Help'
[version]$appDeployHelpScriptVersion = [version]'3.8.4'
[string]$appDeployHelpScriptDate = '26/01/2021'

## Variables: Environment
[string]$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
#  Dot source the App Deploy Toolkit Functions
. "$scriptDirectory\AppDeployToolkitMain.ps1" -DisableLogging
. "$scriptDirectory\AppDeployToolkitExtensions.ps1"
##*===============================================
##* END VARIABLE DECLARATION
##*===============================================

##*===============================================
##* FUNCTION LISTINGS
##*===============================================

Function Show-HelpConsole {
	## Import the Assemblies
	Add-Type -AssemblyName 'System.Windows.Forms' -ErrorAction 'Stop'
	Add-Type -AssemblyName System.Drawing -ErrorAction 'Stop'

	## Form Objects
	$HelpForm = New-Object -TypeName 'System.Windows.Forms.Form'
	$HelpListBox = New-Object -TypeName 'System.Windows.Forms.ListBox'
	$HelpTextBox = New-Object -TypeName 'System.Windows.Forms.RichTextBox'
	$InitialFormWindowState = New-Object -TypeName 'System.Windows.Forms.FormWindowState'

	## Form Code
	$System_Drawing_Size = New-Object -TypeName 'System.Drawing.Size'
	$System_Drawing_Size.Height = 665
	$System_Drawing_Size.Width = 957
	$HelpForm.ClientSize = $System_Drawing_Size
	$HelpForm.DataBindings.DefaultDataSourceUpdateMode = 0
	$HelpForm.Name = 'HelpForm'
	$HelpForm.Text = 'PowerShell App Deployment Toolkit Help Console'
	$HelpForm.WindowState = 'Normal'
	$HelpForm.ShowInTaskbar = $true
	$HelpForm.FormBorderStyle = 'Fixed3D'
	$HelpForm.MaximizeBox = $false
	$HelpForm.Icon = New-Object -TypeName 'System.Drawing.Icon' -ArgumentList $AppDeployLogoIcon
	$HelpListBox.Anchor = 7
	$HelpListBox.BorderStyle = 1
	$HelpListBox.DataBindings.DefaultDataSourceUpdateMode = 0
	$HelpListBox.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList ('Microsoft Sans Serif', 9.75, 1, 3, 1)
	$HelpListBox.FormattingEnabled = $true
	$HelpListBox.ItemHeight = 16
	$System_Drawing_Point = New-Object -TypeName 'System.Drawing.Point'
	$System_Drawing_Point.X = 0
	$System_Drawing_Point.Y = 0
	$HelpListBox.Location = $System_Drawing_Point
	$HelpListBox.Name = 'HelpListBox'
	$System_Drawing_Size = New-Object -TypeName 'System.Drawing.Size'
	$System_Drawing_Size.Height = 658
	$System_Drawing_Size.Width = 271
	$HelpListBox.Size = $System_Drawing_Size
	$HelpListBox.Sorted = $true
	$HelpListBox.TabIndex = 2
	$HelpListBox.add_SelectedIndexChanged({ $HelpTextBox.Text = Get-Help -Name $HelpListBox.SelectedItem -Full | Out-String })
	$helpFunctions = Get-Command -CommandType 'Function' | Where-Object { ($_.HelpUri -match 'psappdeploytoolkit') -and ($_.Definition -notmatch 'internal script function') } | Select-Object -ExpandProperty Name
	$null = $HelpListBox.Items.AddRange($helpFunctions)
	$HelpForm.Controls.Add($HelpListBox)
	$HelpTextBox.Anchor = 11
	$HelpTextBox.BorderStyle = 1
	$HelpTextBox.DataBindings.DefaultDataSourceUpdateMode = 0
	$HelpTextBox.Font = New-Object -TypeName 'System.Drawing.Font' -ArgumentList ('Microsoft Sans Serif', 8.5, 0, 3, 1)
	$HelpTextBox.ForeColor = [System.Drawing.Color]::FromArgb(255, 0, 0, 0)
	$System_Drawing_Point = New-Object -TypeName System.Drawing.Point
	$System_Drawing_Point.X = 277
	$System_Drawing_Point.Y = 0
	$HelpTextBox.Location = $System_Drawing_Point
	$HelpTextBox.Name = 'HelpTextBox'
	$HelpTextBox.ReadOnly = $True
	$System_Drawing_Size = New-Object -TypeName 'System.Drawing.Size'
	$System_Drawing_Size.Height = 658
	$System_Drawing_Size.Width = 680
	$HelpTextBox.Size = $System_Drawing_Size
	$HelpTextBox.TabIndex = 1
	$HelpTextBox.Text = ''
	$HelpForm.Controls.Add($HelpTextBox)

	## Save the initial state of the form
	$InitialFormWindowState = $HelpForm.WindowState
	## Init the OnLoad event to correct the initial state of the form
	$HelpForm.add_Load($OnLoadForm_StateCorrection)
	## Show the Form
	$null = $HelpForm.ShowDialog()
}

##*===============================================
##* END FUNCTION LISTINGS
##*===============================================

##*===============================================
##* SCRIPT BODY
##*===============================================

Write-Log -Message "Load [$appDeployHelpScriptFriendlyName] console..." -Source $appDeployToolkitHelpName

## Show the help console
Show-HelpConsole

Write-Log -Message "[$appDeployHelpScriptFriendlyName] console closed." -Source $appDeployToolkitHelpName

##*===============================================
##* END SCRIPT BODY
##*===============================================

# SIG # Begin signature block
# MIImVgYJKoZIhvcNAQcCoIImRzCCJkMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAGyR37/J5npJHu
# kX20eTERUGXPtkOWAVPNgyZGtw2znqCCH8EwggVvMIIEV6ADAgECAhBI/JO0YFWU
# jTanyYqJ1pQWMA0GCSqGSIb3DQEBDAUAMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQI
# DBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoM
# EUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2Vy
# dmljZXMwHhcNMjEwNTI1MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjBWMQswCQYDVQQG
# EwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS0wKwYDVQQDEyRTZWN0aWdv
# IFB1YmxpYyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQCN55QSIgQkdC7/FiMCkoq2rjaFrEfUI5ErPtx94jGgUW+s
# hJHjUoq14pbe0IdjJImK/+8Skzt9u7aKvb0Ffyeba2XTpQxpsbxJOZrxbW6q5KCD
# J9qaDStQ6Utbs7hkNqR+Sj2pcaths3OzPAsM79szV+W+NDfjlxtd/R8SPYIDdub7
# P2bSlDFp+m2zNKzBenjcklDyZMeqLQSrw2rq4C+np9xu1+j/2iGrQL+57g2extme
# me/G3h+pDHazJyCh1rr9gOcB0u/rgimVcI3/uxXP/tEPNqIuTzKQdEZrRzUTdwUz
# T2MuuC3hv2WnBGsY2HH6zAjybYmZELGt2z4s5KoYsMYHAXVn3m3pY2MeNn9pib6q
# RT5uWl+PoVvLnTCGMOgDs0DGDQ84zWeoU4j6uDBl+m/H5x2xg3RpPqzEaDux5mcz
# mrYI4IAFSEDu9oJkRqj1c7AGlfJsZZ+/VVscnFcax3hGfHCqlBuCF6yH6bbJDoEc
# QNYWFyn8XJwYK+pF9e+91WdPKF4F7pBMeufG9ND8+s0+MkYTIDaKBOq3qgdGnA2T
# OglmmVhcKaO5DKYwODzQRjY1fJy67sPV+Qp2+n4FG0DKkjXp1XrRtX8ArqmQqsV/
# AZwQsRb8zG4Y3G9i/qZQp7h7uJ0VP/4gDHXIIloTlRmQAOka1cKG8eOO7F/05QID
# AQABo4IBEjCCAQ4wHwYDVR0jBBgwFoAUoBEKIz6W8Qfs4q8p74Klf9AwpLQwHQYD
# VR0OBBYEFDLrkpr/NZZILyhAQnAgNpFcF4XmMA4GA1UdDwEB/wQEAwIBhjAPBgNV
# HRMBAf8EBTADAQH/MBMGA1UdJQQMMAoGCCsGAQUFBwMDMBsGA1UdIAQUMBIwBgYE
# VR0gADAIBgZngQwBBAEwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC5jb21v
# ZG9jYS5jb20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNAYIKwYBBQUHAQEE
# KDAmMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZI
# hvcNAQEMBQADggEBABK/oe+LdJqYRLhpRrWrJAoMpIpnuDqBv0WKfVIHqI0fTiGF
# OaNrXi0ghr8QuK55O1PNtPvYRL4G2VxjZ9RAFodEhnIq1jIV9RKDwvnhXRFAZ/ZC
# J3LFI+ICOBpMIOLbAffNRk8monxmwFE2tokCVMf8WPtsAO7+mKYulaEMUykfb9gZ
# pk+e96wJ6l2CxouvgKe9gUhShDHaMuwV5KZMPWw5c9QLhTkg4IUaaOGnSDip0TYl
# d8GNGRbFiExmfS9jzpjoad+sPKhdnckcW67Y8y90z7h+9teDnRGWYpquRRPaf9xH
# +9/DUp/mBlXpnYzyOmJRvOwkDynUWICE5EV7WtgwggYaMIIEAqADAgECAhBiHW0M
# UgGeO5B5FSCJIRwKMA0GCSqGSIb3DQEBDAUAMFYxCzAJBgNVBAYTAkdCMRgwFgYD
# VQQKEw9TZWN0aWdvIExpbWl0ZWQxLTArBgNVBAMTJFNlY3RpZ28gUHVibGljIENv
# ZGUgU2lnbmluZyBSb290IFI0NjAeFw0yMTAzMjIwMDAwMDBaFw0zNjAzMjEyMzU5
# NTlaMFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzAp
# BgNVBAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYwggGiMA0G
# CSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQCbK51T+jU/jmAGQ2rAz/V/9shTUxjI
# ztNsfvxYB5UXeWUzCxEeAEZGbEN4QMgCsJLZUKhWThj/yPqy0iSZhXkZ6Pg2A2NV
# DgFigOMYzB2OKhdqfWGVoYW3haT29PSTahYkwmMv0b/83nbeECbiMXhSOtbam+/3
# 6F09fy1tsB8je/RV0mIk8XL/tfCK6cPuYHE215wzrK0h1SWHTxPbPuYkRdkP05Zw
# mRmTnAO5/arnY83jeNzhP06ShdnRqtZlV59+8yv+KIhE5ILMqgOZYAENHNX9SJDm
# +qxp4VqpB3MV/h53yl41aHU5pledi9lCBbH9JeIkNFICiVHNkRmq4TpxtwfvjsUe
# dyz8rNyfQJy/aOs5b4s+ac7IH60B+Ja7TVM+EKv1WuTGwcLmoU3FpOFMbmPj8pz4
# 4MPZ1f9+YEQIQty/NQd/2yGgW+ufflcZ/ZE9o1M7a5Jnqf2i2/uMSWymR8r2oQBM
# dlyh2n5HirY4jKnFH/9gRvd+QOfdRrJZb1sCAwEAAaOCAWQwggFgMB8GA1UdIwQY
# MBaAFDLrkpr/NZZILyhAQnAgNpFcF4XmMB0GA1UdDgQWBBQPKssghyi47G9IritU
# pimqF6TNDDAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNV
# HSUEDDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEsG
# A1UdHwREMEIwQKA+oDyGOmh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGlnb1B1
# YmxpY0NvZGVTaWduaW5nUm9vdFI0Ni5jcmwwewYIKwYBBQUHAQEEbzBtMEYGCCsG
# AQUFBzAChjpodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2Rl
# U2lnbmluZ1Jvb3RSNDYucDdjMCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0
# aWdvLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEABv+C4XdjNm57oRUgmxP/BP6YdURh
# w1aVcdGRP4Wh60BAscjW4HL9hcpkOTz5jUug2oeunbYAowbFC2AKK+cMcXIBD0Zd
# OaWTsyNyBBsMLHqafvIhrCymlaS98+QpoBCyKppP0OcxYEdU0hpsaqBBIZOtBajj
# cw5+w/KeFvPYfLF/ldYpmlG+vd0xqlqd099iChnyIMvY5HexjO2AmtsbpVn0OhNc
# WbWDRF/3sBp6fWXhz7DcML4iTAWS+MVXeNLj1lJziVKEoroGs9Mlizg0bUMbOalO
# hOfCipnx8CaLZeVme5yELg09Jlo8BMe80jO37PU8ejfkP9/uPak7VLwELKxAMcJs
# zkyeiaerlphwoKx1uHRzNyE6bxuSKcutisqmKL5OTunAvtONEoteSiabkPVSZ2z7
# 6mKnzAfZxCl/3dq3dUNw4rg3sTCggkHSRqTqlLMS7gjrhTqBmzu1L90Y1KWN/Y5J
# KdGvspbOrTfOXyXvmPL6E52z1NZJ6ctuMFBQZH3pwWvqURR8AgQdULUvrxjUYbHH
# j95Ejza63zdrEcxWLDX6xWls/GDnVNueKjWUH3fTv1Y8Wdho698YADR7TNx8X8z2
# Bev6SivBBOHY+uqiirZtg0y9ShQoPzmCcn63Syatatvx157YK9hlcPmVoa1oDE5/
# L9Uo2bC5a4CH2RwwggZCMIIEqqADAgECAhEApU3fcPvc8UxUgrjysXLKMTANBgkq
# hkiG9w0BAQwFADBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1p
# dGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2
# MB4XDTIxMDYwOTAwMDAwMFoXDTI0MDYwODIzNTk1OVowgZUxCzAJBgNVBAYTAlVT
# MREwDwYDVQQIDAhDb2xvcmFkbzEPMA0GA1UEBwwGRGVudmVyMTAwLgYDVQQKDCdN
# ZXRyb3BvbGl0YW4gU3RhdGUgVW5pdmVyc2l0eSBvZiBEZW52ZXIxMDAuBgNVBAMM
# J01ldHJvcG9saXRhbiBTdGF0ZSBVbml2ZXJzaXR5IG9mIERlbnZlcjCCAaIwDQYJ
# KoZIhvcNAQEBBQADggGPADCCAYoCggGBAKboC13rIRz9blQI2n+HkGKRao8qAg0x
# ItxGNohGKXOT1Ua7hDWG5+l2MBpddbQQfMSOyFT+AyisStRfFRb1TU1aSI8QxHJ1
# vkOq64AZKXIKuNxTEQv71RKyTgnjzduII4QqBhsIsrX4vN5PaFq/yKjJqKSsYQjF
# ej4Kx2fORXMFRHnqaAGW7qAwJvKcTUCzVn/1hq9dh6b3TxOd3t1x2L0Paz/4aF+J
# AhkNOF9Gc2B8heToRllTQOOSUdPz3wkW3y7u6zcJMEgxenniTP7fk348hXlrPBjy
# Z7qizCJ3wWH+QRqBqSheKZN/Olw6aYdqLAmbl9LZ3Z0/rvQMk/ADTHsY5jAXwARj
# xAlU+gnxj/6kysS6JDFP+0H7CD3fRlSBOWscPbg314zeGMx8eOLN81WWKu/79S3W
# HWAf84uxNnp2DcV/8aNsjXoaxfdQWXJp6s3V1wf5Jywv7nxcZgtS5+MJzHTv+Yc3
# hPUP7XjLpaAinHf8+rae6yP7OV6r3JZ39QIDAQABo4IByzCCAccwHwYDVR0jBBgw
# FoAUDyrLIIcouOxvSK4rVKYpqhekzQwwHQYDVR0OBBYEFMtdqsyLtKCxfncLB6Dk
# r4Az8FclMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMBEGCWCGSAGG+EIBAQQEAwIEEDBKBgNVHSAEQzBBMDUGDCsGAQQB
# sjEBAgEDAjAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3RpZ28uY29tL0NQUzAI
# BgZngQwBBAEwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL2NybC5zZWN0aWdvLmNv
# bS9TZWN0aWdvUHVibGljQ29kZVNpZ25pbmdDQVIzNi5jcmwweQYIKwYBBQUHAQEE
# bTBrMEQGCCsGAQUFBzAChjhodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29Q
# dWJsaWNDb2RlU2lnbmluZ0NBUjM2LmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
# c3Auc2VjdGlnby5jb20wLQYDVR0RBCYwJIEiaXRzc3lzdGVtZW5naW5lZXJpbmdA
# bXN1ZGVudmVyLmVkdTANBgkqhkiG9w0BAQwFAAOCAYEAf8UAUe7L6IftWT8u5nDy
# eSlAgGxBzj4Dd3xgjRwkshSH7H5TvyTadkZlBBooTL390IG1X1uvLHmOC23qGI0Y
# ytYLCfNcKpq1Jjo8V0Jc9e1RwHGH/z653cJ4TsCYYdGTgtwz1J1OZHHVeMwr0p6y
# 3g7t0ERRuBClq1vnixURJyWRwg7mlSjBriRpv2AKY8xwSB3JMcDF9+YsRYCShih+
# hLcPp4YygkaHjlVhc5K/iKsoS1j7CT4qbjVl077CmVysO8KMDSTATMfOaYFngaxF
# vPfOcqNxCu8n1IMIFnMndoiWe/St3tDdwgSdQQqBxZ24KZZGDqa9j+jlvcO7AviT
# 258+icvZibXngUBM1aTePvMnW91uTJlwyl58K1W2CDnXVps8TZUMXQq8uD9Yn4VA
# 1MDNkfN5meHBUmmiI8ZMHBr2trzM94U/EpTCVK+HuSlOB0oTVC09tMqrcoK3UJXN
# dNc+j+IKHek+dzUcwi4VgmJG+dgrgSXPVPc2s0+AvTfzMIIG7DCCBNSgAwIBAgIQ
# MA9vrN1mmHR8qUY2p3gtuTANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYD
# VQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBS
# U0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTkwNTAyMDAwMDAwWhcNMzgw
# MTE4MjM1OTU5WjB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5j
# aGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
# ZWQxJTAjBgNVBAMTHFNlY3RpZ28gUlNBIFRpbWUgU3RhbXBpbmcgQ0EwggIiMA0G
# CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDIGwGv2Sx+iJl9AZg/IJC9nIAhVJO5
# z6A+U++zWsB21hoEpc5Hg7XrxMxJNMvzRWW5+adkFiYJ+9UyUnkuyWPCE5u2hj8B
# BZJmbyGr1XEQeYf0RirNxFrJ29ddSU1yVg/cyeNTmDoqHvzOWEnTv/M5u7mkI0Ks
# 0BXDf56iXNc48RaycNOjxN+zxXKsLgp3/A2UUrf8H5VzJD0BKLwPDU+zkQGObp0n
# dVXRFzs0IXuXAZSvf4DP0REKV4TJf1bgvUacgr6Unb+0ILBgfrhN9Q0/29DqhYyK
# VnHRLZRMyIw80xSinL0m/9NTIMdgaZtYClT0Bef9Maz5yIUXx7gpGaQpL0bj3duR
# X58/Nj4OMGcrRrc1r5a+2kxgzKi7nw0U1BjEMJh0giHPYla1IXMSHv2qyghYh3ek
# FesZVf/QOVQtJu5FGjpvzdeE8NfwKMVPZIMC1Pvi3vG8Aij0bdonigbSlofe6GsO
# 8Ft96XZpkyAcSpcsdxkrk5WYnJee647BeFbGRCXfBhKaBi2fA179g6JTZ8qx+o2h
# ZMmIklnLqEbAyfKm/31X2xJ2+opBJNQb/HKlFKLUrUMcpEmLQTkUAx4p+hulIq6l
# w02C0I3aa7fb9xhAV3PwcaP7Sn1FNsH3jYL6uckNU4B9+rY5WDLvbxhQiddPnTO9
# GrWdod6VQXqngwIDAQABo4IBWjCCAVYwHwYDVR0jBBgwFoAUU3m/WqorSs9UgOHY
# m8Cd8rIDZsswHQYDVR0OBBYEFBqh+GEZIA/DQXdFKI7RNV8GEgRVMA4GA1UdDwEB
# /wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MBEGA1UdIAQKMAgwBgYEVR0gADBQBgNVHR8ESTBHMEWgQ6BBhj9odHRwOi8vY3Js
# LnVzZXJ0cnVzdC5jb20vVVNFUlRydXN0UlNBQ2VydGlmaWNhdGlvbkF1dGhvcml0
# eS5jcmwwdgYIKwYBBQUHAQEEajBoMD8GCCsGAQUFBzAChjNodHRwOi8vY3J0LnVz
# ZXJ0cnVzdC5jb20vVVNFUlRydXN0UlNBQWRkVHJ1c3RDQS5jcnQwJQYIKwYBBQUH
# MAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQEMBQADggIB
# AG1UgaUzXRbhtVOBkXXfA3oyCy0lhBGysNsqfSoF9bw7J/RaoLlJWZApbGHLtVDb
# 4n35nwDvQMOt0+LkVvlYQc/xQuUQff+wdB+PxlwJ+TNe6qAcJlhc87QRD9XVw+K8
# 1Vh4v0h24URnbY+wQxAPjeT5OGK/EwHFhaNMxcyyUzCVpNb0llYIuM1cfwGWvnJS
# ajtCN3wWeDmTk5SbsdyybUFtZ83Jb5A9f0VywRsj1sJVhGbks8VmBvbz1kteraMr
# Qoohkv6ob1olcGKBc2NeoLvY3NdK0z2vgwY4Eh0khy3k/ALWPncEvAQ2ted3y5wu
# jSMYuaPCRx3wXdahc1cFaJqnyTdlHb7qvNhCg0MFpYumCf/RoZSmTqo9CfUFbLfS
# ZFrYKiLCS53xOV5M3kg9mzSWmglfjv33sVKRzj+J9hyhtal1H3G/W0NdZT1QgW6r
# 8NDT/LKzH7aZlib0PHmLXGTMze4nmuWgwAxyh8FuTVrTHurwROYybxzrF06Uw3hl
# IDsPQaof6aFBnf6xuKBlKjTg3qj5PObBMLvAoGMs/FwWAKjQxH/qEZ0eBsambTJd
# tDgJK0kHqv3sMNrxpy/Pt/360KOE2See+wFmd7lWEOEgbsausfm2usg1XTN2jvF8
# IAwqd661ogKGuinutFoAsYyr4/kKyVRd1LlqdJ69SK6YMIIG9jCCBN6gAwIBAgIR
# AJA5f5rSSjoT8r2RXwg4qUMwDQYJKoZIhvcNAQEMBQAwfTELMAkGA1UEBhMCR0Ix
# GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
# MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSUwIwYDVQQDExxTZWN0aWdvIFJTQSBU
# aW1lIFN0YW1waW5nIENBMB4XDTIyMDUxMTAwMDAwMFoXDTMzMDgxMDIzNTk1OVow
# ajELMAkGA1UEBhMCR0IxEzARBgNVBAgTCk1hbmNoZXN0ZXIxGDAWBgNVBAoTD1Nl
# Y3RpZ28gTGltaXRlZDEsMCoGA1UEAwwjU2VjdGlnbyBSU0EgVGltZSBTdGFtcGlu
# ZyBTaWduZXIgIzMwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCQsnE/
# eeHUuYoXzMOXwpCUcu1aOm8BQ39zWiifJHygNUAG+pSvCqGDthPkSxUGXmqKIDRx
# e7slrT9bCqQfL2x9LmFR0IxZNz6mXfEeXYC22B9g480Saogfxv4Yy5NDVnrHzgPW
# AGQoViKxSxnS8JbJRB85XZywlu1aSY1+cuRDa3/JoD9sSq3VAE+9CriDxb2YLAd2
# AXBF3sPwQmnq/ybMA0QfFijhanS2nEX6tjrOlNEfvYxlqv38wzzoDZw4ZtX8fR6b
# WYyRWkJXVVAWDUt0cu6gKjH8JgI0+WQbWf3jOtTouEEpdAE/DeATdysRPPs9zdDn
# 4ZdbVfcqA23VzWLazpwe/OpwfeZ9S2jOWilh06BcJbOlJ2ijWP31LWvKX2THaygM
# 2qx4Qd6S7w/F7KvfLW8aVFFsM7ONWWDn3+gXIqN5QWLP/Hvzktqu4DxPD1rMbt8f
# vCKvtzgQmjSnC//+HV6k8+4WOCs/rHaUQZ1kHfqA/QDh/vg61MNeu2lNcpnl8TIt
# UfphrU3qJo5t/KlImD7yRg1psbdu9AXbQQXGGMBQ5Pit/qxjYUeRvEa1RlNsxfTh
# hieThDlsdeAdDHpZiy7L9GQsQkf0VFiFN+XHaafSJYuWv8at4L2xN/cf30J7qusc
# 6es9Wt340pDVSZo6HYMaV38cAcLOHH3M+5YVxQIDAQABo4IBgjCCAX4wHwYDVR0j
# BBgwFoAUGqH4YRkgD8NBd0UojtE1XwYSBFUwHQYDVR0OBBYEFCUuaDxrmiskFKkf
# ot8mOs8UpvHgMA4GA1UdDwEB/wQEAwIGwDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB
# /wQMMAoGCCsGAQUFBwMIMEoGA1UdIARDMEEwNQYMKwYBBAGyMQECAQMIMCUwIwYI
# KwYBBQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMAgGBmeBDAEEAjBEBgNV
# HR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29SU0FU
# aW1lU3RhbXBpbmdDQS5jcmwwdAYIKwYBBQUHAQEEaDBmMD8GCCsGAQUFBzAChjNo
# dHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29SU0FUaW1lU3RhbXBpbmdDQS5j
# cnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLnNlY3RpZ28uY29tMA0GCSqGSIb3
# DQEBDAUAA4ICAQBz2u1ocsvCuUChMbu0A6MtFHsk57RbFX2o6f2t0ZINfD02oGnZ
# 85ow2qxp1nRXJD9+DzzZ9cN5JWwm6I1ok87xd4k5f6gEBdo0wxTqnwhUq//EfpZs
# K9OU67Rs4EVNLLL3OztatcH714l1bZhycvb3Byjz07LQ6xm+FSx4781FoADk+AR2
# u1fFkL53VJB0ngtPTcSqE4+XrwE1K8ubEXjp8vmJBDxO44ISYuu0RAx1QcIPNLiI
# ncgi8RNq2xgvbnitxAW06IQIkwf5fYP+aJg05Hflsc6MlGzbA20oBUd+my7wZPvb
# pAMxEHwa+zwZgNELcLlVX0e+OWTOt9ojVDLjRrIy2NIphskVXYCVrwL7tNEunTh8
# NeAPHO0bR0icImpVgtnyughlA+XxKfNIigkBTKZ58qK2GpmU65co4b59G6F87VaA
# pvQiM5DkhFP8KvrAp5eo6rWNes7k4EuhM6sLdqDVaRa3jma/X/ofxKh/p6FIFJEN
# gvy9TZntyeZsNv53Q5m4aS18YS/to7BJ/lu+aSSR/5P8V2mSS9kFP22GctOi0MBk
# 0jpCwRoD+9DtmiG4P6+mslFU1UzFyh8SjVfGOe1c/+yfJnatZGZn6Kow4NKtt32x
# akEnbgOKo3TgigmCbr/j9re8ngspGGiBoZw/bhZZSxQJCZrmrr9gFd2G9TGCBesw
# ggXnAgEBMGkwVDELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRl
# ZDErMCkGA1UEAxMiU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5nIENBIFIzNgIR
# AKVN33D73PFMVIK48rFyyjEwDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgcYn0gr5vRIpu
# EZk/COZA8W3ubMVGFKOwIqSI//oy/K8wDQYJKoZIhvcNAQEBBQAEggGACYff0Mbd
# TKpXkXbciFEehkhZikXlpC+tP1mo2LOsbPoFtU/Agl/JZREUBLlgwua2MHsfHqjO
# Tho6YKrD8kMOYFw0vyhuQlOI9wkCq01Oz0mUCIT0rSU6SgIr6T4tMw5IvhoQl5Kp
# FyIJ0xEKjsdfVjvKWHVkQVsrJO4A7jXWZKvvyF35ryPHq8VsmA2W24vgwu03fdMv
# 75abSwFNZKYa1wmIBILTckEa1lLGbJAHZO6muYFRcB/BZvIz3mh68J9E/IyXIcQq
# bXsq0m0gyJHQbQY8uTu5Lj55y4v3cZlfYmkZO4rbvyuhDLTYoQoAVBu2Vo8epuzy
# kt4iJWRBRRgCDJUEBgl0mBhRQQNltPq5wpfG975Z0eS2G6vjlFYwsuCgZK2BqcVd
# v5OfKFJxsgeU7py+1kBptX61WHYRunjujVRJWjf4txsP/rMVn99Z/lpOMlrgyUQN
# U0nCTa/TNo4afj3tpkgW6eGV5JEnYGNoApDJ2fmUvvrXBfEmh+2WIS/yoYIDTDCC
# A0gGCSqGSIb3DQEJBjGCAzkwggM1AgEBMIGSMH0xCzAJBgNVBAYTAkdCMRswGQYD
# VQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNV
# BAoTD1NlY3RpZ28gTGltaXRlZDElMCMGA1UEAxMcU2VjdGlnbyBSU0EgVGltZSBT
# dGFtcGluZyBDQQIRAJA5f5rSSjoT8r2RXwg4qUMwDQYJYIZIAWUDBAICBQCgeTAY
# BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjA2MDcx
# OTQ2NTZaMD8GCSqGSIb3DQEJBDEyBDAfux6P4/d7mJU+s2rqusx3pJnd33SJ0JPo
# ss8YnT3leTpvhCSv+85/t/g99EXUscwwDQYJKoZIhvcNAQEBBQAEggIAXVsjMCeO
# 9Xl26uyPIa4hodpou097ftsYtmJgNwb92+seGTcT2SVOPKY9TGdbeAAQKLecSvdt
# 16IDSIQrZf1DU0vgeKPTeTusKOdH1UT5AvDlY9XK36Y7167EGW26d5lN9O3RnFFw
# zeKQvWKOXi76kRW+aQoebJjz7uzKb/q2LU6kh+/BuvDaIbG7pynkrThZGax49H6Y
# Bxcckst10MsdXW1egI4Kf+QNxw9NKMJrzBnO5HYZWUQ3oOy47hKfRbgBCWBa2Qqb
# 2ebPhvouQoyI7hCYALDjA1ebpF4y6619ZD/vJOW/velvr6sH+FmORxNT+/C+jIwl
# aKslDNUufw1iKRAoCjnwOsucIoUyZaKKd8GgXkPi4iwbGmFwzdNqScfVBwrRA6dL
# oqq+PGdXWfpKHoP1KbSicAqQmXLKuzNl+ygp9fO+xJBJJKIhe75fqvQi/A5QROn7
# 0a35uH29IdTmxxnu88ohMcL6O2RXdgGTMJqDTzNFTdol4o0q3HbjdNYV6TK48YGY
# qTzjNUOF7SA5YpajtUKDIfq2Tiz554RlQIxAqGcwefygJXLl5ufIpiD41/DFNgf4
# 5bVdGnup/E8NJBsSNjuSWvL706nQBN4VVGbzAgiQuFf+1IUlVrsrlOwgj8/Re5wW
# DZnucAiW8HaxlTrDLT68F56n40B/1sb7Ac4=
# SIG # End signature block
