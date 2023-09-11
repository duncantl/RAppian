a!localVariables(
  local!loggedInUser: loggedInUser(),
  local!prmResponse: #"84012a2f-0bbb-4c4a-8869-936be6830974"(loginId: local!loggedInUser),
  local!isIntegrationSuccess: index(local!prmResponse, "success", true()),
  local!fullPrmData: if(
    local!isIntegrationSuccess,
    index(
      index(local!prmResponse, "result", null),
      "body",
      null
    ),
    null
  ),
  local!isStudent: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_113063"(prmData: local!fullPrmData),
  local!studentPrmDetails: if(
    and(
      local!isStudent,
      #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(ri!studentDetails)
    ),
    #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_218191"(email: user(local!loggedInUser, "email")),
    {}
  ),
  local!studentDetails: if(
    ri!isUpdate,
    ri!studentDetails,
    #"urn:appian:record-type:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c"(
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/f611f2dc-5793-4eb4-a970-87a8dcc0771b": index(
        local!studentPrmDetails,
        "studentId",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/5a9e552b-8a8a-4fde-8999-18327ff3a3a1": index(local!studentPrmDetails, "email", null),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/cff89e12-a40c-4857-b397-9ccea4bdb21f": index(
        local!studentPrmDetails,
        "firstName",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/7cb18828-e22b-4e6c-9a98-2315d1d4a397": index(
        local!studentPrmDetails,
        "lastName",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/8aed353c-2a02-4e63-b0fc-57988e2a488f": index(
        local!studentPrmDetails,
        "graduateProgram",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/fa8a4aeb-c944-4754-8dcd-c4b511c01584": index(
            local!studentPrmDetails,
            "programCode",
            null
          ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/7c147912-5fd1-4fda-90c6-f272585c3a31": index(
        local!studentPrmDetails,
        "degreeObjective",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/a05ebad9-4091-411f-9e68-8f66e8fef1d5": index(
        local!studentPrmDetails,
        "designatedEmphasis",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/551d485b-a03a-42d3-9cac-f4e7660c5a77": index(
        local!studentPrmDetails,
        "majorProfessor",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/a2ae8ad5-9604-4770-b37c-1d9649583ccd": index(
        local!studentPrmDetails,
        "majorProfessorEmail",
        null
      ),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/6f61b9f1-f865-4ed7-be4f-bedddd7ea9d9": loggedInUser(),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/dda0cd98-522a-41fa-a4d6-5ef842c6336a": loggedInUser(),
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/5ded25c0-e33e-4738-9018-7654ae87996f": true
    )
  ),
  local!degObj: if(
    a!isNullOrEmpty(
      index(
        local!studentDetails,
        #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/fa8a4aeb-c944-4754-8dcd-c4b511c01584",
        null
      )
    ),
    null,
    a!flatten(
      #"SYSTEM_SYSRULES_forEach"(
      items: reject(
        a!isNullOrEmpty(_),
        split(
          index(
            local!studentDetails,
            #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/fa8a4aeb-c944-4754-8dcd-c4b511c01584",
            null
          ),
          ";"
        )
      ),
      expression: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_198221"(
        programCode: trim(fv!item),
        degreeObj: trim(
          index(
            split(
              index(
                local!studentDetails,
                #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/7c147912-5fd1-4fda-90c6-f272585c3a31",
                null()
              ),
              ";"
            ),
            fv!index,
            null()
          )
        )
      )
    ))
  ),
  local!degPathway: if(
    or(
      #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
        ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"]
      ),
      count(
        index(
          local!degObj,
          #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f",
          null()
        )
      ) > 1
    ),
    index(
      local!degObj,
      #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/9690916b-1c36-451b-b507-907052dca04f",
      null()
    ),
    index(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_198221"(
        id: ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"]
      ),
      #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/9690916b-1c36-451b-b507-907052dca04f",
      null()
    )
  ),
  local!readOnly: false(),
  local!atcRequestId: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_202674"(
    studentId: local!studentDetails[#"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/f611f2dc-5793-4eb4-a970-87a8dcc0771b"],
    degPathway: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_222889"(
      degreePlan: index(
        local!degObj,
        wherecontains(
          tointeger(
            ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"]
          ),
          tointeger(
            index(
              local!degObj,
              #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f",
              null()
            )
          )
        ),
        null()
      )
    )
  ),
  local!iscandidacyStatusApproved: if(
    #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(local!atcRequestId),
    false(),
    true()
  ),
  local!manualCandidacyStatus: ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"],
  local!atcCommitteeMembers: if(
    ri!isUpdate,
    ri!commiteeMembersDetails,
    null/*if(
      a!isNotNullOrEmpty(local!atcRequestId),
      index(
        rule!EFRM_QR_getCommitteeMemberDetails(
          requestId: local!atcRequestId,
          isActive: true()
        ),
        "data",
        null()
      ),
      if(
        and(
          length({ local!degPathway }) >= 1,
          a!isNullOrEmpty(
            tointeger(index(
              index(
                local!degObj,
                'recordType!{b221313a-e0b1-4bf1-8933-00949adcfbf3}EFRM Degree Plan Map.fields.{066395cd-923b-4339-a617-1aa321fb1349}minCommitteeMembers',
                null()
              ),
              wherecontains(
                tointeger(index(ri!filingDetails, 'recordType!{399a7de1-fe9b-4024-80f1-bd7b5a094577}EFRM Filing Details.fields.{a011c633-0d74-4092-b182-e1751fbe2103}degreePathway', "")),
                tointeger(index(local!degObj, 'recordType!{b221313a-e0b1-4bf1-8933-00949adcfbf3}EFRM Degree Plan Map.fields.{ae1ae808-c5b4-4df5-8a6e-fa586495be8f}id', ""))
              ),
              null
            ))
          )
          ),
        a!forEach(
          items: enumerate(
            tointeger(index(index(
              index(
                local!degObj,
                'recordType!{b221313a-e0b1-4bf1-8933-00949adcfbf3}EFRM Degree Plan Map.fields.{066395cd-923b-4339-a617-1aa321fb1349}minCommitteeMembers',
                null()
              ),
              wherecontains(
                tointeger(index(ri!filingDetails, 'recordType!{399a7de1-fe9b-4024-80f1-bd7b5a094577}EFRM Filing Details.fields.{a011c633-0d74-4092-b182-e1751fbe2103}degreePathway', "")),
                tointeger(index(local!degObj, 'recordType!{b221313a-e0b1-4bf1-8933-00949adcfbf3}EFRM Degree Plan Map.fields.{ae1ae808-c5b4-4df5-8a6e-fa586495be8f}id', ""))
              ),
              null
            ), 1, ""))
          ) + 1,
          expression: rule!EFRM_createOrUpdateCommitteeMember(isActive: true())
        ),
        null
      )
    )*/
  ),
  /*local!atcCommitteeMembers: local!committeeMembers,*/
  local!lookupDetails: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_54182"(
    categoryId: {
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_170912",
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_195932",
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_182921"
    }
  ),
  local!isStudentAvailableInDE: a!isNotNullOrEmpty(
    index(
      local!studentDetails,
      #"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/a05ebad9-4091-411f-9e68-8f66e8fef1d5",
      null
    )
  ),
  /*  Variables for documents*/
  local!signedTitlePage: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_177921",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!abstract: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_177927",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!docCertificates: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_177955",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!deCompletionReport: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_177976",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!deApplication: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_178008",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!gacApplication: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_195662",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!gacReport: index(
    ri!documentDetails,
    wherecontains(
      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_195669",
      tointeger(
        index(
          ri!documentDetails,
          #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/1fbdec7e-9bcb-4589-a387-6addfd158e8f",
          null
        )
      )
    ),
    null
  ),
  local!removedCommitteeMembers,
  local!existingDocumentDetails: ri!documentDetails,
  local!removedDocuments,
  local!facultyProgramCodes: if(
    local!isStudent,
    null,
    #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_183346"(prmData: local!fullPrmData)
  ),
  local!isReqOutOfProgram: a!refreshVariable(
    value: and(
      not(local!readOnly = true),
      not(
        #"urn:appian:function:v1:a:isusermemberofgroup?okey=a!isUserMemberOfGroup"(
          username: local!loggedInUser,
          groups: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_61856"
        )
      ),
      a!isNotNullOrEmpty(
        value: index(
          ri!filingDetails,
          #"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103",
          ""
        )
      ),
      if(
        local!isStudent = true,
        false,
        not(
          contains(
            touniformstring(local!facultyProgramCodes),
            tostring(
              index(
                index(
                  local!degObj,
                  wherecontains(
                    tointeger(
                      index(
                        ri!filingDetails,
                        #"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103",
                        ""
                      )
                    ),
                    tointeger(
                      index(
                        local!degObj,
                        #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f",
                        ""
                      )
                    )
                  ),
                  null
                ),
                #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/9690916b-1c36-451b-b507-907052dca04f",
                ""
              )
            )
          )
        )
      )
    ),
    refreshOnVarChange: { local!studentDetails }
  ),
  local!isGPCAllowed,
  #"SYSTEM_SYSRULES_formLayout_v1"(
    contents: {
      #"SYSTEM_SYSRULES_columnsLayout"(
        columns: {
          #"SYSTEM_SYSRULES_columnLayout"(width: "EXTRA_NARROW"),
          #"SYSTEM_SYSRULES_columnLayout"(
            contents: {
              #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_146511"(
                requestId: ri!requestDetails[#"urn:appian:record-field:v1:5ad7f584-ce54-41f6-a287-5fcf34d87702/b3b96eb8-996b-44bb-b614-34e3dc4badf7"]
              ),
              #"SYSTEM_SYSRULES_cardLayout"(
                contents: {
                  #"SYSTEM_SYSRULES_richTextDisplayField"(
                    labelPosition: "COLLAPSED",
                    value: {
                      "Welcome! This form collects all of the information you need in order to file to graduate. It's a big step, and we'll have a few questions and requests for you. If you have any questions about any piece of this process, your Graduate Program Coordinator and Graduate Advisor are great first points of contact. We also encourage you to chat about the graduation process with your Graduate Studies Senior Academic Advisor (SAA). If you have not already done so, you can set up a meeting with your SAA at ",
                      #"SYSTEM_SYSRULES_richTextItem_v1"(
                        text: { "appointments.ucdavis.edu" },
                        link: #"SYSTEM_SYSRULES_safeLink"(
                          uri: "https://appointments.ucdavis.edu/",
                          openLinkIn: "NEW_TAB"
                        ),
                        linkStyle: "INLINE"
                      ),
                      ". For now, though, let's get started!"
                    }
                  )
                },
                height: "AUTO",
                style: "TRANSPARENT",
                marginBelow: "STANDARD",
                showBorder: false,
                showShadow: true
              ),
              #"SYSTEM_SYSRULES_cardLayout"(
                contents: {
                  if(
                    local!readOnly,
                    #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_193339"(requestDetails: ri!requestDetails),
                    {}
                  ),
                  #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_146802"(
                    studentDetails: local!studentDetails,
                    studentPrmDetails: local!studentPrmDetails,
                    isStudent: local!isStudent,
                    isReview: local!readOnly,
                    loggedInuser: local!loggedInUser,
                    degObj: local!degObj,
                    isStudentAvailableInDE: local!isStudentAvailableInDE,
                    filingDetails: ri!filingDetails
                  ),
                  #"SYSTEM_SYSRULES_richTextDisplayField"(),
                  #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_147198"(
                    isReview: local!readOnly,
                    fillingDetails: ri!filingDetails,
                    studentDetails: local!studentDetails,
                    degPathway: local!degPathway,
                    degObj: local!degObj,
                    committeeMemberDetails: ri!commiteeMembersDetails,
                    isGPCAllowed: local!isGPCAllowed,
                    loggedInUser: local!loggedInUser,
                    isReqOutOfProgram: local!isReqOutOfProgram
                  ),
                  #"SYSTEM_SYSRULES_richTextDisplayField"(),
                  #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_157520"(
                    isReview: local!readOnly,
                    /*manualCandidacyStatus: local!manualCandidacyStatus,*/
                    iscandidacyStatusApproved: local!iscandidacyStatusApproved,
                    filingDetails: ri!filingDetails,
                    isGPCAllowed: local!isGPCAllowed,
                    atcRequestId: local!atcRequestId
                  ),
                  #"SYSTEM_SYSRULES_richTextDisplayField"(),
                  if(
                    and(
                      or(
                        local!manualCandidacyStatus,
                        local!iscandidacyStatusApproved
                      ),
                      if(
                        #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                          ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"],
                          
                        ),
                        length(
                          {
                            local!studentDetails[#"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/fa8a4aeb-c944-4754-8dcd-c4b511c01584"]
                          }
                        ) = 1,
                        true()
                      )
                    ),
                    {
                      #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_157602"(
                        filingDetails: ri!filingDetails,
                        isReview: local!readOnly,
                        loggedInUser: local!loggedInUser,
                        signedTitlePage: local!signedTitlePage,
                        abstract: local!abstract,
                        doctorateCertificates: local!docCertificates,
                        
                      ),
                      if(
                        toboolean(
                          ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/c566f663-d06e-4a36-803e-6e3164199d86"]
                        ) = true(),
                        {
                          #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_157673"(
                            filingDetails: ri!filingDetails,
                            isReview: local!readOnly,
                            loggedInUser: local!loggedInUser,
                            studentDetails: local!studentDetails,
                            isStudentAvaiableInDE: local!isStudentAvailableInDE,
                            deApplication: local!deApplication,
                            deCompletionReport: local!deCompletionReport
                          ),
                          #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_157685"(
                            filingDetails: ri!filingDetails,
                            isReview: local!readOnly,
                            loggedInUser: local!loggedInUser,
                            gacApplication: local!gacApplication,
                            gacReport: local!gacReport
                          ),
                          if(
                            tostring(index(
                              index(
                                local!degObj,
                              wherecontains(
                                tointeger(index(ri!filingDetails, #"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103", {})),
                                tointeger(index(local!degObj, #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f", {}))
                              ),
                              null
                            ), #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/cc32581f-79d7-4b35-9237-50c5f5f16381", null)) = "Plan II",
                            {},
                            #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_158515"(
                            filingDetails: ri!filingDetails,
                            isReview: local!readOnly,
                            loggedInUser: local!loggedInUser,
                            commiteeMembersRoles: index(
                              local!lookupDetails,
                              wherecontains(
                                #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_195932",
                                tointeger(
                                  index(
                                    local!lookupDetails,
                                    #"urn:appian:record-field:v1:a959cec9-97e5-46ca-9274-d693b4afbd93/7b937fc4-085e-41b2-a8f7-c1e15bb2e5cd",
                                    null
                                  )
                                )
                              ),
                              null
                            ),
                            commiteeMemberDetails: ri!commiteeMembersDetails,
                            /*commiteeMemberDetails: ri!commiteeMembersDetails,*/
                            removedCommitteeMembers: local!removedCommitteeMembers,
                            degPathway: local!degPathway,
                            committeeMembersBR: index(
                              local!degObj,
                              wherecontains(
                                tointeger(
                                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"]
                                ),
                                tointeger(
                                  index(
                                    local!degObj,
                                    #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f",
                                    null
                                  )
                                )
                              ),
                              null
                            )
                          )
                          ),
                          #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_158891"(
                            filingDetails: ri!filingDetails,
                            isReview: local!readOnly,
                            lookupDetailsForEmbargoType: index(
                              local!lookupDetails,
                              wherecontains(
                                #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_170912",
                                tointeger(index(
                                  local!lookupDetails,
                                  #"urn:appian:record-field:v1:a959cec9-97e5-46ca-9274-d693b4afbd93/7b937fc4-085e-41b2-a8f7-c1e15bb2e5cd",
                                  null
                                ))
                              ),
                              null
                            ),
                            /*degPathway: local!degPathway,*/
                            lookupForEmbargoLength: index(
                              local!lookupDetails,
                              wherecontains(
                                #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_182921",
                                index(
                                  local!lookupDetails,
                                  #"urn:appian:record-field:v1:a959cec9-97e5-46ca-9274-d693b4afbd93/7b937fc4-085e-41b2-a8f7-c1e15bb2e5cd",
                                  null
                                )
                              ),
                              null
                            )
                          ),
                          #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_158986"(
                            filingDetails: ri!filingDetails,
                            notes: ri!notes,
                            isReview: local!readOnly,
                            loggedInUser: local!loggedInUser
                          )
                        },
                        {}
                      )
                    },
                    {}
                  )
                }
              )
            }
          )
        }
      )
    },
    buttons: #"SYSTEM_SYSRULES_ButtonLayout"(
      primaryButtons: {
        #"SYSTEM_SYSRULES_ButtonWidget"(
          label: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_47151",
          value: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_47151",
          loadingIndicator: true(),
          icon: "floppy-o",
          saveInto: {
            a!save(ri!buttonAction, save!value),
            a!save(
              ri!requestDetails,
              #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_58765"(
                requestDetails: ri!requestDetails,
                workflowId: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_190718",
                eFormId: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_190724",
                isOnBehalfOfReq: false,
                initiatedBy: local!loggedInUser,
                initiatedOn: now(),
                modifiedBy: local!loggedInUser,
                modifiedOn: now(),
                isActive: true,
                status: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_193704"[2],
                stage: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_190768"[2]
              )
            ),
            a!save(ri!studentDetails, local!studentDetails),
            a!save(
              {
                ri!studentDetails[#"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/e96f0d64-b9f9-46bd-b233-f8f4820d07f2"],
                ri!studentDetails[#"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/ba419eb4-7fd3-4d4c-a5d1-db15468b24c7"]
              },
              now()
            ),
            a!save(
              ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/836b4fa4-eb14-4af4-926a-8425f7f0e432"],
              local!loggedInUser
            ),
            a!save(
              ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/6ae47e07-d2ea-497f-a774-3488ccd13544"],
              now()
            ),
            a!save(
              ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"],
              if(
                #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"],
                  
                ),
                index(
                  local!degObj,
                  #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f",
                  null()
                ),
                ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"]
              )
            ),
            a!save(
              ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"],
              if(
                #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"],
                  
                ),
                local!iscandidacyStatusApproved,
                ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"]
              )
            ),
            a!save(
              ri!documentDetails,
              reject(
                a!isNullOrEmpty(_),
                {
                  local!signedTitlePage,
                  local!abstract,
                  local!docCertificates,
                  local!deCompletionReport,
                  local!deApplication,
                  local!gacApplication,
                  local!gacReport
                }
              )
            ),
            a!save(
              ri!taskLogDetails,
              if(
                #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                  index(
                    ri!taskLogDetails,
                    #"urn:appian:record-field:v1:f46db558-8af9-47a4-88a7-c759a0b3445f/50feef5d-b031-4f1f-bf98-def767c26c0e",
                    null
                  )
                ),
                ri!taskLogDetails,
                #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_147887"(
                  taskLogDetails: ri!taskLogDetails,
                  acceptedOn: now(),
                  acceptedBy: local!loggedInUser,
                  completedBy: local!loggedInUser,
                  completedOn: now(),
                  isActive: true(),
                  isCompleted: true()
                )
              )
            ),
            a!save(
              ri!commiteeMembersDetails,
              reject(
                a!isNullOrEmpty(_),
                append(
                  ri!commiteeMembersDetails,
                  local!removedCommitteeMembers
                )
              )
            ),
            a!save(
              local!removedDocuments,
              index(
                local!existingDocumentDetails,
                wherecontains(
                  tointeger(
                    reject(
                      a!isNullOrEmpty(_),
                      difference(
                        tointeger(
                          index(
                            local!existingDocumentDetails,
                            #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                            null()
                          )
                        ),
                        tointeger(
                          index(
                            ri!documentDetails,
                            #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                            null()
                          )
                        )
                      )
                    )
                  ),
                  tointeger(
                    index(
                      local!existingDocumentDetails,
                      #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                      null()
                    )
                  )
                ),
                null()
              )
            ),
            if(
              #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                index(
                  local!removedDocuments,
                  #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                  null()
                )
              ),
              {},
              {
                a!save(
                  local!removedDocuments[#"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/9b15b538-1e35-4463-8843-0e859cf6c3eb"],
                  false()
                ),
                a!save(
                  ri!documentDetails,
                  reject(
                    a!isNullOrEmpty(_),
                    append(
                      ri!documentDetails,
                      local!removedDocuments
                    )
                  )
                )
              }
            )
          },
          submit: true(),
          validate: false,
          showWhen: and(
            or(
              toboolean(local!iscandidacyStatusApproved) = true(),
              toboolean(local!manualCandidacyStatus) = true()
            ),
            toboolean(
              ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/c566f663-d06e-4a36-803e-6e3164199d86"]
            ) = true()
          ),
          disabled: local!isReqOutOfProgram = true()
        ),
        if(
          local!readOnly = true,
          {
            #"SYSTEM_SYSRULES_ButtonWidget"(
              label: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_47145",
              value: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_47145",
              icon: "paper-plane",
              saveInto: {
                a!save(ri!buttonAction, save!value),
                a!save(
                  ri!requestDetails,
                  #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_58765"(
                    requestDetails: ri!requestDetails,
                    workflowId: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_190718",
                    eFormId: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_190724",
                    isOnBehalfOfReq: false,
                    initiatedBy: local!loggedInUser,
                    initiatedOn: now(),
                    modifiedBy: local!loggedInUser,
                    modifiedOn: now(),
                    isActive: true,
                    status: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_193704"[1],
                    stage: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_190768"[2]
                  )
                ),
                a!save(ri!studentDetails, local!studentDetails),
                a!save(
                  {
                    ri!studentDetails[#"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/e96f0d64-b9f9-46bd-b233-f8f4820d07f2"],
                    ri!studentDetails[#"urn:appian:record-field:v1:f874526a-c78e-4cb5-ac77-23bda1053b1c/ba419eb4-7fd3-4d4c-a5d1-db15468b24c7"]
                  },
                  now()
                ),
                a!save(
                  ri!taskLogDetails,
                  if(
                    #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                      index(
                        ri!taskLogDetails,
                        #"urn:appian:record-field:v1:f46db558-8af9-47a4-88a7-c759a0b3445f/50feef5d-b031-4f1f-bf98-def767c26c0e",
                        null
                      )
                    ),
                    ri!taskLogDetails,
                    #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_147887"(
                      taskLogDetails: ri!taskLogDetails,
                      acceptedOn: now(),
                      acceptedBy: local!loggedInUser,
                      completedBy: local!loggedInUser,
                      completedOn: now(),
                      isActive: true(),
                      isCompleted: true()
                    )
                  )
                ),
                a!save(
                  ri!commiteeMembersDetails,
                  reject(
                    a!isNullOrEmpty(_),
                    append(
                      ri!commiteeMembersDetails,
                      local!removedCommitteeMembers
                    )
                  )
                ),
                a!save(
                  local!removedDocuments,
                  index(
                    local!existingDocumentDetails,
                    wherecontains(
                      reject(
                        a!isNullOrEmpty(_),
                        difference(
                          tointeger(
                            index(
                              local!existingDocumentDetails,
                              #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                              null()
                            )
                          ),
                          tointeger(
                            index(
                              ri!documentDetails,
                              #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                              null()
                            )
                          )
                        )
                      ),
                      index(
                        local!existingDocumentDetails,
                        #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                        null()
                      )
                    ),
                    null()
                  )
                ),
                if(
                  #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                    index(
                      local!removedDocuments,
                      #"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/ae380310-5701-44a8-bddc-9aa781a41c40",
                      null()
                    )
                  ),
                  {},
                  {
                    a!save(
                      local!removedDocuments[#"urn:appian:record-field:v1:3126e56d-456d-4b76-a46b-3d610e957723/9b15b538-1e35-4463-8843-0e859cf6c3eb"],
                      false()
                    ),
                    a!save(
                      ri!documentDetails,
                      reject(
                        a!isNullOrEmpty(_),
                        append(
                          ri!documentDetails,
                          local!removedDocuments
                        )
                      )
                    )
                  }
                )
              },
              submit: true(),
              validate: true(),
              style: "PRIMARY",
              showWhen: local!readOnly = true
            )
          },
          {
            #"SYSTEM_SYSRULES_ButtonWidget"(
              label: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_62058",
              value: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_62058",
              icon: "pencil-square-o",
              saveInto: {
                a!save(local!readOnly, true),
                a!save(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/836b4fa4-eb14-4af4-926a-8425f7f0e432"],
                  local!loggedInUser
                ),
                a!save(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/6ae47e07-d2ea-497f-a774-3488ccd13544"],
                  now()
                ),
                a!save(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"],
                  if(
                    #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                      ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"],
                      
                    ),
                    index(
                      local!degObj,
                      #"urn:appian:record-field:v1:b221313a-e0b1-4bf1-8933-00949adcfbf3/ae1ae808-c5b4-4df5-8a6e-fa586495be8f",
                      null()
                    ),
                    ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/a011c633-0d74-4092-b182-e1751fbe2103"]
                  )
                ),
                a!save(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"],
                  if(
                    #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                      ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"],
                      
                    ),
                    local!iscandidacyStatusApproved,
                    ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/0b5793c9-5eee-4077-9640-9fa1071515cb"]
                  )
                ),
                a!save(
                  ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/5640a39f-2d9f-4f33-8e21-47d09fb8bba7"],
                  if(
                    #"_a-0000dd9c-9656-8000-9ccd-01ef9001ef90_37557"(
                      ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/5640a39f-2d9f-4f33-8e21-47d09fb8bba7"]
                    ),
                    local!isStudentAvailableInDE,
                    ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/5640a39f-2d9f-4f33-8e21-47d09fb8bba7"]
                  )
                ),
                a!save(
                  ri!documentDetails,
                  reject(
                    a!isNullOrEmpty(_),
                    {
                      local!signedTitlePage,
                      local!abstract,
                      local!docCertificates,
                      local!deCompletionReport,
                      local!deApplication,
                      local!gacApplication,
                      local!gacReport
                    }
                  )
                )
              },
              submit: false,
              validate: true(),
              style: "PRIMARY",
              loadingIndicator: false,
              disabled: local!isReqOutOfProgram = true(),
              showWhen: and(
                local!readOnly = false(),
                and(
                  or(
                    toboolean(local!iscandidacyStatusApproved) = true(),
                    toboolean(local!manualCandidacyStatus) = true()
                  ),
                  toboolean(
                    ri!filingDetails[#"urn:appian:record-field:v1:399a7de1-fe9b-4024-80f1-bd7b5a094577/c566f663-d06e-4a36-803e-6e3164199d86"]
                  ) = true()
                )
              )
            )
          }
        )
      },
      secondaryButtons: {
        #"SYSTEM_SYSRULES_ButtonWidget"(
          label: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_62121",
          value: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_62121",
          icon: "sign-out",
          saveInto: a!save(ri!buttonAction, save!value),
          submit: true,
          validate: false
        ),
        #"SYSTEM_SYSRULES_ButtonWidget"(
          label: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_165488",
          value: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_165488",
          icon: "trash",
          saveInto: a!save(ri!buttonAction, save!value),
          submit: true,
          validate: false,
          confirmHeader: "CONFIRMATION",
          confirmMessage: "Are you sure, you want to withdraw this application?",
          showWhen: ri!isUpdate = true()
        ),
        #"SYSTEM_SYSRULES_ButtonWidget"(
          label: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_62064",
          value: #"_a-0000ea6a-ed23-8000-9bab-011c48011c48_62064",
          icon: "step-backward",
          saveInto: { a!save(local!readOnly, false) },
          submit: false,
          showWhen: local!readOnly = true,
          validate: false
        )
      }
    )
  )
)