//
//  GlobalVariable.swift
//  STEP
//
//  Created by apple on 10/06/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
var headType = ""
let ECATLECAT = "ECATLECAT"
let FUNGAT = "FUNGAT"
let MDCATLMDCAT = "MDCATLMDCAT"
let ETEAFUNGAT = "ETEAFUNGAT"
let NAT = "NAT"
let ETEANTS = "ETEANTS"
let ETEAENGINEERING = "ETEAENGINEERING"
let ETEAMEDICAL = "ETEAMEDICAL"
let NUMS = "NUMS"
let FULLACCESS =  "-1"
let NONE = "NONE"
let ECATTESTSESSION = "ECATTESTSESSION"
let ETEAMEDICALTESTSESSION = "ETEAMEDICALTESTSESSION"
func getType(vrf:String)->String{
    switch vrf {
    case "STEP ECAT/LECAT","STEP L.ECAT","ECAT/LECAT","L.ECAT":
        return ECATLECAT
    case "STEP FUNGAT","FUNGAT":
        return FUNGAT
    case "STEP MDCAT","LMDCAT (all med uni)","STEP MDCAT (Crash Program)", "STEP LMDCAT (All Medical Universities)","STEP L.MDCAT (UHS Exclusive)","MDCAT","LMDCAT","L.MDCAT (UHS Exclusive)" :
        return MDCATLMDCAT
    case "STEP ETEA FUNGAT","ETEA FUNGAT":
        return ETEAFUNGAT
    case "STEP NAT (NTS)","NAT (NTS)":
        return NAT
    case "STEP ETEA NTS","ETEA NTS":
        return ETEANTS
    case "STEP ETEA ENGG","STEP L.ETEA ENGG","ETEA ENGG","L.ETEA ENGG":
        return ETEAENGINEERING
    case "STEP ETEA MEDICAL","STEP L.ETEA MEDICAL","STEP L.ETEA MEDICAL(with NUMS)",   "STEP ETEA MEDICAL (CRASH PROG)","ETEA MEDICAL" ,"L.ETEA MEDICAL","L.ETEA MEDICAL(with NUMS)","ETEA MEDICAL (CRASH PROG)","" :
        return ETEAMEDICAL
    case "STEP NUMS (Exclusive)":
        return NUMS
    case "-1":
        return FULLACCESS
    case "ECAT (FSC) (TEST SESSION)","ECAT (FSC) TEST SESSION","ECAT (ICS) (TEST SESSION)","ECAT (ICS) TEST SESSION":
        return ECATTESTSESSION
    case "ETEA MEDICAL (TEST SESSION)","ETEA MEDICAL TEST SESSION":
        return ETEAMEDICALTESTSESSION
    default:
        return NONE
    }
}
func getDropDownData(vrf:String, batch: Int)->[DropDownModel]{
    
    let type = getType(vrf: vrf)
    switch type {
    case ECATLECAT:
        var data = [DropDownModel]()
        data.append(DropDownModel(1, "8aa08620-cab9-44f4-b884-d24f0951ef62", "ECAT/LECAT", "(FSC)"))
        data.append(DropDownModel(2, "8aa08620-cab9-44f4-b886-d24f0951ef65", "ECAT/LECAT", "(ICS)"))
        if batch == 1 || batch == 2{
           data.append(DropDownModel(21, "fc27bb7a-989c-4174-9824-7686fb965a0a", "NTS", ""))
       }
        return data
    case FUNGAT:
        var data = [DropDownModel]()
        data.append(DropDownModel(3, "b08cbe37-93dd-4b67-8e64-7d80a0347740", "FUNGAT", "(FSC)"))
        data.append(DropDownModel(4, "b08cbe37-93dd-4b67-8e67-7d80a0347746", "FUNGAT", "(ICS)"))
        if batch == 1{
            data.append(DropDownModel(21, "fc27bb7a-989c-4174-9824-7686fb965a0a", "NTS", ""))
        }
        return data
    case MDCATLMDCAT:
        var data = [DropDownModel]()
        if batch == 1{
             data.append(DropDownModel(24, "6da2d7ca-f2ba-4ded-b1e1-0ad3f92adfed", "ETEA MEDICAL", "TEST SESSION"))
        }
        data.append(DropDownModel(5, "fc27bb7a-989c-4174-9822-7686fb965a0f", "MDCAT/LMDCAT", ""))
        return data
    case ETEAMEDICAL:
        var data = [DropDownModel]()
        data.append(DropDownModel(6, "dd0de5b2-cd6a-4b75-80a4-1b00473cfc3a", "ETEA MEDICAL", ""))
        return data
    case ETEAENGINEERING:
        var data = [DropDownModel]()
        data.append(DropDownModel(7, "3d0de5a1-cd6d-4b23-80a2-1b00473cfc5b", "ETEA ENGINEERING", "(FSC)"))
        data.append(DropDownModel(8, "3d0de5b1-cd6d-4b53-80a2-1b00473cfc5c", "ETEA ENGINEERING", "(ICS)"))
        return data
    case ETEAFUNGAT:
        var data = [DropDownModel]()
        data.append(DropDownModel(9, "3d0de5a2-cd6d-4b25-80a2-1b00473cfc5a", "ETEA FUNGAT", "(FSC)"))
        data.append(DropDownModel(10, "3d0de5a2-cd6d-4b25-80a5-1b00473cfc5b", "ETEA FUNGAT", "(ICS)"))
        return data
    case FULLACCESS:
        var data = [DropDownModel]()
        data.append(DropDownModel(11, "8aa08620-cab9-44f4-b884-d24f0951ef62", "ECAT/LECAT", "(FSC)"))
        data.append(DropDownModel(12, "8aa08620-cab9-44f4-b886-d24f0951ef65", "ECAT/LECAT", "(ICS)"))
        data.append(DropDownModel(13, "b08cbe37-93dd-4b67-8e64-7d80a0347740", "FUNGAT", "(FSC)"))
               data.append(DropDownModel(14, "b08cbe37-93dd-4b67-8e67-7d80a0347746", "FUNGAT", "(ICS)"))
                data.append(DropDownModel(15, "fc27bb7a-989c-4174-9822-7686fb965a0f", "MDCAT/LMDCAT", ""))
          data.append(DropDownModel(16, "dd0de5b2-cd6a-4b75-80a4-1b00473cfc3a", "ETEA MEDICAL", ""))
        data.append(DropDownModel(17, "3d0de5a1-cd6d-4b23-80a2-1b00473cfc5b", "ETEA ENGINEERING", "(FSC)"))
        data.append(DropDownModel(18, "3d0de5b1-cd6d-4b53-80a2-1b00473cfc5c", "ETEA ENGINEERING", "(ICS)"))
       data.append(DropDownModel(19, "3d0de5a2-cd6d-4b25-80a2-1b00473cfc5a", "ETEA FUNGAT", "(FSC)"))
              data.append(DropDownModel(20, "3d0de5a2-cd6d-4b25-80a5-1b00473cfc5b", "ETEA FUNGAT", "(ICS)"))
        data.append(DropDownModel(21, "fc27bb7a-989c-4174-9824-7686fb965a0a", "NTS", ""))
        data.append(DropDownModel(22, "8aa08620-cab9-44f4-b834-d24f0951ec62", "ECAT/LECAT", "(FSC) TEST SESSION"))
        data.append(DropDownModel(22, "fc27bb7a-989c-4174-9422-7686fb965f0f", "ECAT/LECAT", "(ICS) TEST SESSION"))
         data.append(DropDownModel(24, "6da2d7ca-f2ba-4ded-b1e1-0ad3f92adfed", "ETEA MEDICAL", "TEST SESSION"))
        return data
    case NAT:
        var data = [DropDownModel]()
        data.append(DropDownModel(21, "fc27bb7a-989c-4174-9824-7686fb965a0a", "NTS", ""))
        return data
    case ECATTESTSESSION:
        var data = [DropDownModel]()
        data.append(DropDownModel(22, "8aa08620-cab9-44f4-b834-d24f0951ec62", "ECAT/LECAT", "(FSC) TEST SESSION"))
      data.append(DropDownModel(23, "fc27bb7a-989c-4174-9422-7686fb965f0f", "ECAT/LECAT", "(ICS) TEST SESSION"))
        return data
        case ETEAMEDICALTESTSESSION:
            var data = [DropDownModel]()
               
            data.append(DropDownModel(24, "6da2d7ca-f2ba-4ded-b1e1-0ad3f92adfed", "ETEA MEDICAL", "TEST SESSION"))
          
            return data
    default:
       return [DropDownModel]()
    }
}

func getSchemeLink(vrf:String, batch: Int)-> String{

let type = getType(vrf: vrf)
    switch type {
    case ECATLECAT,FUNGAT :
        if batch == 1{
            return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/NTS/NTS-SOS.pdf?sp=r&st=2020-06-18T12:05:02Z&se=2022-06-19T12:05:00Z&sv=2019-10-10&sig=G1d3fR9CUCtJFeB37tfshCHIVtgzS%2F%2FXsxrt8x8nR%2Bc%3D&sr=f"
        }
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/SchemeOfStudy.pdf?sp=r&st=2020-05-13T13:11:36Z&se=2026-05-14T13:11:00Z&sv=2019-10-10&sig=QwWrNy8la8FiKitADA8%2FpTkNxdQhjdeqg8h8lx87bGs%3D&sr=f"
        
    case MDCATLMDCAT:
        
        if batch == 1{
            return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/MDCATTESTSESSINSOS.pdf?sp=r&st=2020-08-20T06:03:02Z&se=2022-08-21T06:03:00Z&sv=2019-12-12&sig=K3zLrpfW6gYfuIGairVoEX7sn86tOUqZVITiiejUCfQ%3D&sr=f"
        }
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/MDCAT%20SOS.pdf?sp=r&st=2020-05-31T14:08:17Z&se=2021-06-01T14:08:00Z&sv=2019-10-10&sig=3vqeHuF3xMpBxR0gWbEiT1CWGiTfWorDWi%2BVfQoCLb0%3D&sr=f"
    case ETEAENGINEERING,ETEAFUNGAT:
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/ETEA-ENGINEERING-FSC.pdf?sp=r&st=2020-05-31T14:06:58Z&se=2021-06-01T14:06:00Z&sv=2019-10-10&sig=1Pj5fIYGkQmYeHgteqvhVxul4VfBAwflisC5KgzgC4E%3D&sr=f"
    case ETEAMEDICAL:
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/ETEA-MEDICAL.pdf?sp=r&st=2020-05-31T14:13:10Z&se=2022-06-01T14:13:00Z&sv=2019-10-10&sig=Owrp9%2FOiapNYAXswTz8wFBWX5CjBboRZ9Gheq5zFqb4%3D&sr=f"
    case NAT:
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/NTS/NTS-SOS.pdf?sp=r&st=2020-06-18T12:05:02Z&se=2022-06-19T12:05:00Z&sv=2019-10-10&sig=G1d3fR9CUCtJFeB37tfshCHIVtgzS%2F%2FXsxrt8x8nR%2Bc%3D&sr=f"
    case ECATTESTSESSION:
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/ETEA-ENGINEERING-FSC.pdf?sp=r&st=2020-05-31T14:06:58Z&se=2021-06-01T14:06:00Z&sv=2019-10-10&sig=1Pj5fIYGkQmYeHgteqvhVxul4VfBAwflisC5KgzgC4E%3D&sr=f"
    case ETEAMEDICALTESTSESSION:
        return "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/Resources/ETEAMEDICALTESTSESSIONSOS.pdf?sp=r&st=2020-08-20T06:01:38Z&se=2022-08-21T06:01:00Z&sv=2019-12-12&sig=Dk%2B5J26%2FQ15mW0GRiZjFOUJpvLdfG6hnbtUE5FREim4%3D&sr=f"
    default:
      return  "https://elhelpfiles.azureedge.net/pgcelfiles/STEP/NTS/NTS-SOS.pdf?sp=r&st=2020-06-18T12:05:02Z&se=2022-06-19T12:05:00Z&sv=2019-10-10&sig=G1d3fR9CUCtJFeB37tfshCHIVtgzS%2F%2FXsxrt8x8nR%2Bc%3D"
    }

}

func getTestType(head:String)-> String{
    switch head {
    case "ETEA MEDICAL":
        return ETEAMEDICAL
    case "MDCAT/LMDCAT":
        return MDCATLMDCAT
    default:
        return ""
    }
}
