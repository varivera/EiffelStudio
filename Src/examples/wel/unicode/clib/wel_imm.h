extern EIF_POINTER cwel_get_keyboard_layout(void);
extern EIF_INTEGER cwel_get_keyboard_layout_list (EIF_INTEGER arraySize, EIF_POINTER list);
extern EIF_BOOLEAN cwel_get_keyboard_layout_name (EIF_POINTER buff);
extern EIF_POINTER cwel_load_keyboard_layout(EIF_POINTER hKl, EIF_INTEGER flags);
extern EIF_INTEGER cwel_get_imm_property (EIF_POINTER hKl, EIF_INTEGER propInfo);
extern EIF_INTEGER cwel_get_imm_description (EIF_POINTER hKL, EIF_POINTER description, EIF_INTEGER uBuflen);
extern EIF_INTEGER cwel_get_imm_ime_filename (EIF_POINTER hKL, EIF_POINTER description, EIF_INTEGER uBuflen);
extern EIF_POINTER cwel_get_imm_context (EIF_POINTER hWnd);
extern EIF_POINTER cwel_imm_create_context (void);
extern EIF_POINTER cwel_imm_associate_context (EIF_POINTER hWnd, EIF_POINTER hImc);
extern EIF_BOOLEAN cwel_imm_destroy_context (EIF_POINTER hImc);
extern EIF_BOOLEAN cwel_get_imm_is_ime (EIF_POINTER hKl);
extern EIF_BOOLEAN cwel_set_imm_release_context(EIF_POINTER hWnd, EIF_POINTER hIMC);
extern EIF_BOOLEAN cwel_set_open_status (EIF_POINTER hIMC, EIF_BOOLEAN fOpen);
extern EIF_POINTER cwel_activate_keyboard_layout (EIF_POINTER hKl, EIF_INTEGER flags);
extern EIF_INTEGER cwel_langid_from_locale(EIF_POINTER hKl);
extern EIF_INTEGER cwel_primary_langid_from_langid (EIF_POINTER hKl);
extern EIF_INTEGER cwel_sub_langid_from_langid (EIF_POINTER hKl);
extern EIF_INTEGER cwel_localeid_from_langid (EIF_INTEGER langid, EIF_INTEGER sort_id);
extern EIF_BOOLEAN cwel_imm_configure_ime (EIF_POINTER hKl, EIF_POINTER hWnd, EIF_INTEGER flag, EIF_INTEGER mode);
extern EIF_BOOLEAN cwel_imm_get_conversion_status (EIF_POINTER input_cont, EIF_POINTER conv_mode, EIF_POINTER sent_mode);
extern EIF_POINTER cwel_install_ime (EIF_POINTER path, EIF_POINTER file);
extern EIF_INTEGER cwel_imm_get_composition_string (EIF_POINTER hImc, EIF_INTEGER type, EIF_POINTER buffer, EIF_INTEGER bytes);
extern EIF_BOOLEAN cwel_imm_set_composition_string (EIF_POINTER hImc, EIF_INTEGER type, EIF_POINTER cbuffer, EIF_INTEGER cbytes, EIF_POINTER rbuffer, EIF_INTEGER rbytes);
extern EIF_BOOLEAN cwel_get_conversion_status (EIF_POINTER input_cont, EIF_POINTER conv_mode, EIF_POINTER sent_mode);
extern EIF_BOOLEAN cwel_set_conversion_status (EIF_POINTER input_cont, EIF_INTEGER conv_mode, EIF_INTEGER sent_mode);
extern EIF_INTEGER cwel_imm_get_candidate_list_count (EIF_POINTER hImc, EIF_INTEGER cnt);
extern EIF_BOOLEAN cwel_ime_move_composition_window (EIF_POINTER hImc, EIF_INTEGER style, EIF_INTEGER xpos, EIF_INTEGER ypos);
extern EIF_BOOLEAN cwel_ime_move_status_window (EIF_POINTER hImc, EIF_INTEGER xpos, EIF_INTEGER ypos);

