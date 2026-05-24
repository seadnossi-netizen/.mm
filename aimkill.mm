bool isBuggyPlayer(void *player) {//fix Damage not dealt 

    if (player == NULL) return true;

    return equals(ff->get_NickName(player), CreateString("")) ||
           equals(ff->GameObject_GetTag(ff->Component_GetGameObject(player)),
                  CreateString("Untagged"));

}



void TakeDamagePVE(uint AttackableEntityID, uint RealDamage, uint DamageValue, uint DamagerID,
                   int WeaponDataID, int8_t HitBodyPart, uint TickCount, Vector3 FirePos,
                   Vector3 TargetPos, float CheckParams = 0) {

    void *Class_messageTakeDamage2 = *(void **) ff->getRealOffset(
            static_cast<uintptr_t>(stol(string(AY_OBFUSCATE(_Class_messageTakeDamage)), nullptr,
                                        16)));
    if (Class_messageTakeDamage2) {
        LOGI("Class_messageTakeDamage2 OK");
        void *TakeDamage2 = ff->message(Class_messageTakeDamage2);
        if (TakeDamage2) {
            LOGI("TakeDamage2 OK");
            ff->C2S_RUDP_TakeDamage_Req_ctor(TakeDamage2);
            *(uint *) ((uint64_t) TakeDamage2 +
                       stoi(string(AY_OBFUSCATE(_AttackableEntityID)), nullptr,
                            16)) = AttackableEntityID;
            *(uint *) ((uint64_t) TakeDamage2 +
                       stoi(string(AY_OBFUSCATE(_RealDamage)), nullptr, 16)) = RealDamage;
            *(uint *) ((uint64_t) TakeDamage2 +
                       stoi(string(AY_OBFUSCATE(_DamageValue)), nullptr, 16)) = DamageValue;
            *(uint *) ((uint64_t) TakeDamage2 +
                       stoi(string(AY_OBFUSCATE(_DamagerID)), nullptr, 16)) = DamagerID;
            *(int *) ((uint64_t) TakeDamage2 +
                      stoi(string(AY_OBFUSCATE(_WeaponDataID)), nullptr, 16)) = WeaponDataID;
            *(int8_t *) ((uint64_t) TakeDamage2 +
                         stoi(string(AY_OBFUSCATE(_HitBodyPart)), nullptr, 16)) = HitBodyPart;
            *(uint *) ((uint64_t) TakeDamage2 +
                       stoi(string(AY_OBFUSCATE(_TickCount)), nullptr, 16)) = TickCount;
            *(void **) ((uint64_t) TakeDamage2 +
                        stoi(string(AY_OBFUSCATE(_FirePos)), nullptr, 16)) = ff->PackVector3Pos(
                    FirePos);
            *(void **) ((uint64_t) TakeDamage2 +
                        stoi(string(AY_OBFUSCATE(_TargetPos)), nullptr, 16)) = ff->PackVector3Pos(
                    TargetPos);
            *(float *) ((uint64_t) TakeDamage2 +
                        stoi(string(AY_OBFUSCATE(_CheckParams)), nullptr, 16)) = CheckParams;
            //*(float  *) ((uint64_t) TakeDamage2 + stoi(string(AY_OBFUSCATE(_realtimeSinceStartup)), nullptr, 16)) = ff->Time_get_realtimeSinceStartup();
            ff->GameFacade_Send(static_cast<uint>(stoi(string(AY_OBFUSCATE(_RUDP_TAKE_DAMAGE)))),
                                TakeDamage2, 2, 1);

        }
    } else {
        if (!funcoes.checkTakeDamage2 && currentTarget && currentTarget->object) {
            void *CurrentLocalPlayer = ff->GameFacade_CurrentLocalPlayer(); //m_LocalPlayer
            if (!CurrentLocalPlayer) return;
            uint PlayerID1 = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID);
            uint PlayerID2 = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID2);
            uint PlayerID3 = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID3);
            uint PlayerID4 = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID4);
            uint PlayerID5 = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID5);
            uint PlayerID6 = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID6);
            ff->COW_GamePlay_NetworkAIPawn(currentTarget->object, 1, PlayerID1, PlayerID2,
                                           PlayerID3, PlayerID4, PlayerID5, PlayerID6, 0, -1,
                                           Vector3(0, 0, 0), Vector3(0, 0, 0), 0, 0);
            funcoes.checkTakeDamage2 = true;
        }
    }

    return;

}


int count6 = 0;

void AutoSkillAll(void *currentTimer, void *player) {

    if (!currentTimer) return;

    void *CurrentLocalPlayer = ff->GameFacade_CurrentLocalPlayer(); //m_LocalPlayer
    if (!CurrentLocalPlayer) return;
    uint CurrentLocalPlayerID = *(uint *) ((uint64_t) CurrentLocalPlayer + _PlayerID);
    if (CurrentLocalPlayerID == 0) return;
    LOGI("Auto Skill init");
    if (funcoes.AutoSKill != -1 && !funcoes.GotForceSyncState) {
        void *CurrentLocalPlayerDataHeadTF = ff->Player_GetHeadTF(CurrentLocalPlayer);
        if (!CurrentLocalPlayerDataHeadTF) return;
        void *CurrentLocalPlayerDataHeadTF2 = ff->Component_GetTransform(
                CurrentLocalPlayerDataHeadTF);
        if (!CurrentLocalPlayerDataHeadTF2) return;
        LOGI("autoskill 2");
        //Vector3 CurrentLocalPlayerHeadLocation = ff->Transform_get_position(CurrentLocalPlayerDataHeadTF2);
        Vector3 CurrentLocalPlayerHeadLocation = ff->Transform_get_position(
                CurrentLocalPlayerDataHeadTF2);

        void *PlayerDataHeadTF = ff->Player_GetHeadTF(player);
        if (!PlayerDataHeadTF) return;
        void *PlayerDataHeadTF2 = ff->Component_GetTransform(PlayerDataHeadTF);
        if (!PlayerDataHeadTF2) return;
        Vector3 PlayerHeadLocation = ff->Transform_get_position(PlayerDataHeadTF2);

        void *Weapon = ff->Player_GetWeaponOnHand(CurrentLocalPlayer);
        if (!Weapon) return;
        uint WeaponUniqueID = *(uint *) ((uint64_t) Weapon + _WeaponUniqueID_Var);
        LOGI("WeaponUniqueID %d", WeaponUniqueID);
        int AmmoCapacity = ff->Weapon_get_AmmoCapacity(Weapon);
        LOGI("AmmoCapacity %d", AmmoCapacity);
        if (player != NULL
            && player != CurrentLocalPlayer
            && !ff->Player_IsLocalTeammate(player)
            && !ff->Player_IsReallyDead(player)
            && !ff->AttackableEntity_IsDead(player)
            && ff->AttackableEntity_IsVisible(player)
            && !ff->Player_get_IsDieing(player)
            && !ff->Player_get_IsPendingRevive(player)
            && !ff->Player_get_IsOnBoard(player)
            && !isBuggyPlayer(player)
            && ((isEnemyInRangeWeapon(player) && isVisible(player) && funcoes.AutoSKillWeapon)
                || (isEnemyInRangeWeapon(player) && !funcoes.AutoSKillWeapon &&
                    ff->Weapon_IsInfinityAmmo(Weapon)))) {//unlimited damage 
            uint playerID = *(uint *) ((uint64_t) player + _PlayerID);
            LOGI("playerID : %d", playerID);

            while (count6 <= funcoes.ChernobylSpeed) {
                funcoes.TimerChernobyl++;
                funcoes.TimerRepeatFireInterval++;
                if (funcoes.TimerChernobyl >= funcoes.AutoSKillSMOOTH) {
                    if (!funcoes.StartFireSkillAll && funcoes.StopFireSkillAll) {
                        /*if (!ff->Weapon_IsInfinityAmmo(Weapon)) {
                            //LOGI("OKAY MUNDO!");
                            StartFire(CurrentLocalPlayerID, WeaponUniqueID,ff->TimeService_get_TickCount(currentTimer),_ESTARTFIRESTATE_READY);
                        }*/
                        //StartFire(CurrentLocalPlayerID, WeaponUniqueID,ff->TimeService_get_TickCount(currentTimer),_ESTARTFIRESTATE_FIRE);
                        LOGI("Start fire começou");
                        StartFire();
                        LOGI("Start fire");
                        funcoes.StartFireSkillAll = true;
                        funcoes.TakeDamageSkillAll = 0;
                        funcoes.StopFireSkillAll = false;
                        funcoes.TimerRepeatFireInterval = 0;
                    }
                    if (funcoes.TakeDamageSkillAll < 2 && funcoes.StartFireSkillAll &&
                        funcoes.TimerRepeatFireInterval >=
                        ff->Weapon_get_RepeatFireInterval(Weapon) * 10) {
                        if (CurrentLocalPlayerHeadLocation != Vector3(0, 0, 0) &&
                            playerID) {
                            uint GetDamage = (uint) ff->Weapon_GetDamage(Weapon, 0);
                            LOGI("GetDamage %d", GetDamage);
                            void *WeaponData = ff->Weapon_GetWeaponData(Weapon);
                            uint WeaponDataID = 0;
                            if (WeaponData) {
                                WeaponDataID = *(uint *) ((uint64_t) WeaponData + _ID);
                                LOGI("WeaponDataID %d", WeaponDataID);
                            }
                            if (funcoes.AutoSKill == 1) {
                                funcoes.HitPartyBody = 2;
                            } else {
                                funcoes.HitPartyBody = 1;
                            }

                            LOGI("fireposdef");
                            void *FirePosDef = ff->PackVector3Pos(CurrentLocalPlayerHeadLocation);
                            LOGI("TargetPosDef");
                            void *TargetPosDef = ff->PackVector3Pos(PlayerHeadLocation);
                            LOGI("TargetPosDef OK");
                            if (GetDamage && FirePosDef && TargetPosDef &&
                                funcoes.HitPartyBody != 0 && WeaponDataID) {
                                //LOGI("TakeDamagePVE init");
                                //CmdTakeDamage(playerID, GetDamage,(uint) (GetDamage | (uint) (funcoes.HitPartyBody << 24)),CurrentLocalPlayerID, WeaponDataID, funcoes.HitPartyBody,ff->TimeService_get_TickCount(currentTimer), 0, 0, 0, 0, 0, 0,0, 0, 0);
                                //TakeDamage(player, CurrentLocalPlayerHeadLocation, PlayerHeadLocation, 0, 0, 0);
                                TakeDamagePVE(playerID, GetDamage, (uint) (GetDamage |
                                                                           (uint) (funcoes.HitPartyBody
                                                                                   << 24)),
                                              CurrentLocalPlayerID, WeaponDataID,
                                              funcoes.HitPartyBody,
                                              ff->TimeService_get_TickCount(currentTimer),
                                              CurrentLocalPlayerHeadLocation, PlayerHeadLocation,
                                              0);
                                LOGI("TakeDamagePVE OK");
                            }
                        }
                        funcoes.TakeDamageSkillAll++;
                        funcoes.StopFireSkillAll = false;
                        funcoes.TimerRepeatFireInterval = 0;
                        // funcoes.TimerTakeDamage = 0;
                        // funcoes.TimerStopFire = 0;
                    }

                    if (!funcoes.StopFireSkillAll && funcoes.TakeDamageSkillAll >= 2) {
                        LOGI("STOP FIre!");
                        StopFire(CurrentLocalPlayerID, WeaponUniqueID, (uint16_t) AmmoCapacity, 0,
                                 0);
                        LOGI("StopFire OK");
                        funcoes.StopFireSkillAll = true;
                        funcoes.StartFireSkillAll = false;
                        funcoes.TimerChernobyl = 0;
                    }

                }
                count6++;
            }
            if (count6 >= funcoes.ChernobylSpeed) {
                count6 = 0;
            }
        }
    } else {
        if (!funcoes.StopFireSkillAll && funcoes.StartFireSkillAll) {
            void *Weapon = ff->Player_GetWeaponOnHand(CurrentLocalPlayer);
            if (!Weapon) return;
            uint WeaponUniqueID = *(uint *) ((uint64_t) Weapon + _WeaponUniqueID_Var);
            int AmmoCapacity = ff->Weapon_get_AmmoCapacity(Weapon);
            //LOGI("CallSetAimRotationCount : %d", CallSetAimRotationCount);
            LOGI("STOP FIre a!");
            StopFire(CurrentLocalPlayerID, WeaponUniqueID, (uint16_t) AmmoCapacity, 0, 0);
            LOGI("StopFire OK a");
            funcoes.StopFireSkillAll = true;
            funcoes.StartFireSkillAll = false;
        }
    }


    return;

}

void AutoSKIll(void *player) {

    void *currentTimer = ff->GameFacade_CurrentGameSimulationTimer();
    if (!currentTimer) {
        return;
    }
/*
    //void * GameFacade = *(void **) ff->getRealOffset(_COW_GameFacade_c);
    //if(GameFacade){
    //void * GameFacadeBase = *(void **)((uint64_t)GameFacade + _static_fields);
    //if(GameFacadeBase){
    //u_long GameServerMatchID = *(u_long *)((uint64_t)GameFacadeBase + 0x40);
    //u_long GameServerServiceMatchID = *(u_long *)((uint64_t)GameFacadeBase + 0x48);
    //if(GameServerMatchID == GameServerServiceMatchID) return;
    //}
    //}
*/
    if ((me && me->object && !ff->Player_get_IsDriver(me->object)) || !me || !me->object) {
        AutoSkillAll(currentTimer, player);
    }

    return;
}

void (*orig_Player_Update)(void *player, float gameTime, float deltaTime);

void hook_Player_Update(void *player, float gameTime, float deltaTime) {
    if (player) {

        AutoSKIll(player);
        
        }
        
        
        }

