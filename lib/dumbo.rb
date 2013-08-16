require "ffi"

# Wraps the gumbo HTML5 parser written by Google
#
module Dumbo
  extend FFI::Library

  ffi_lib "/usr/local/lib/libgumbo.so.1.0.0"

  enum :gumbo_node_type,   [:node_document, :node_element, :node_text, :node_cdata, :node_comment, :node_whitespace]
  enum :gumbo_parse_flags, [:insertion_normal,                           0,
                            :insertion_by_parser,                        1 << 0,
                            :insertion_implicit_end_tag,                 1 << 1,
                            :insertion_implied,                          1 << 3,
                            :insertion_converted_from_end_tag,           1 << 4,
                            :insertion_from_is_index,                    1 << 5,
                            :insertion_from_image,                       1 << 6,
                            :insertion_reconstructed_fromatting_element, 1 << 7,
                            :insertion_adoption_agency_cloned,           1 << 8,
                            :insertion_adoption_agency_moved,            1 << 9,
                            :insertion_foster_parented,                  1 << 10
  ]

  enum :gumbo_namespace_enum, [ :namespace_html, :namespace_svg, :namespace_mathml ]

  enum :gumbo_tag, [:tag_html, :tag_head, :tag_title, :tag_base, :tag_link, :tag_meta, :tag_style, :tag_script, :tag_noscript, :tag_body, :tag_section, :tag_nav, :tag_article, :tag_aside, :tag_h1, :tag_h2, :tag_h3, :tag_h4, :tag_h5, :tag_h6, :tag_hgroup, :tag_header, :tag_footer, :tag_address, :tag_p, :tag_hr, :tag_pre, :tag_blockquote, :tag_ol, :tag_ul, :tag_li, :tag_dl, :tag_dt, :tag_dd, :tag_figure, :tag_figcaption, :tag_div, :tag_a, :tag_em, :tag_strong, :tag_small, :tag_s, :tag_cite, :tag_q, :tag_dfn, :tag_abbr, :tag_time, :tag_code, :tag_var, :tag_samp, :tag_kbd, :tag_sub, :tag_sup, :tag_i, :tag_b, :tag_mark, :tag_ruby, :tag_rt, :tag_rp, :tag_bdi, :tag_bdo, :tag_span, :tag_br, :tag_wbr, :tag_ins, :tag_del, :tag_image, :tag_img, :tag_iframe, :tag_embed, :tag_object, :tag_param, :tag_video, :tag_audio, :tag_source, :tag_track, :tag_canvas, :tag_map, :tag_area, :tag_math, :tag_mi, :tag_mo, :tag_mn, :tag_ms, :tag_mtext, :tag_mglyph, :tag_malignmark, :tag_annotation_xml, :tag_svg, :tag_foreignobject, :tag_desc, :tag_table, :tag_caption, :tag_colgroup, :tag_col, :tag_tbody, :tag_thead, :tag_tfoot, :tag_tr, :tag_td, :tag_th, :tag_form, :tag_fieldset, :tag_legend, :tag_label, :tag_input, :tag_button, :tag_select, :tag_datalist, :tag_optgroup, :tag_option, :tag_textarea, :tag_keygen, :tag_output, :tag_progress, :tag_meter, :tag_details, :tag_summary, :tag_command, :tag_menu, :tag_applet, :tag_acronym, :tag_bgsound, :tag_dir, :tag_frame, :tag_frameset, :tag_noframes, :tag_isindex, :tag_listing, :tag_xmp, :tag_nextid, :tag_noembed, :tag_plaintext, :tag_rb, :tag_strike, :tag_basefont, :tag_big, :tag_blink, :tag_center, :tag_font, :tag_marquee, :tag_multicol, :tag_nobr, :tag_spacer, :tag_tt, :tag_u, :tag_unknown, :tag_last]

  enum :gumbo_insertion_mode, [ :initial, :before_html, :before_head, :in_head, :in_head_noscript, :after_head, :in_body, :text, :in_table, :in_table_text, :in_caption, :in_column_group, :in_table_body, :in_row, :in_cell, :in_select, :in_select_in_table, :after_body, :in_frameset, :after_frameset, :after_after_body, :after_after_frameset ]

  enum :gumbo_error_type, [ :utf8_invalid, :utf8_truncated, :utf8_null, :numeric_char_ref_no_digits, :numeric_char_ref_without_semicolon, :numeric_char_ref_invalid, :named_char_ref_without_semicolon, :named_char_ref_invalid, :tag_starts_with_question, :tag_eof, :tag_invalid, :close_tag_empty, :close_tag_eof, :close_tag_invalid, :script_eof, :attr_name_eof, :attr_name_invalid, :attr_double_quote_eof, :attr_single_quote_eof, :attr_unquoted_eof, :attr_unquoted_right_bracket, :attr_unquoted_equals, :attr_after_eof, :attr_after_invalid, :duplicate_attr, :solidus_eof, :solidus_invalid, :dashes_or_doctype, :comment_eof, :comment_invalid, :comment_bang_after_double_dash, :comment_dash_after_double_dash, :comment_space_after_double_dash, :comment_end_bang_eof, :doctype_eof, :doctype_invalid, :doctype_space, :doctype_right_bracket, :doctype_space_or_right_bracket, :doctype_end, :parser, :unacknowledged_self_closing_tag ]

  enum :gumbo_tokenizer_error_state, [ :tokenizer_data, :tokenizer_char_ref, :tokenizer_rcdata, :tokenizer_rawtext, :tokenizer_plaintext, :tokenizer_script, :tokenizer_tag, :tokenizer_self_closing_tag, :tokenizer_attr_name, :tokenizer_attr_value, :tokenizer_markup_declaration, :tokenizer_comment, :tokenizer_doctype, :tokenizer_cdata ]

  enum :gumbo_token_type, [ :doctype, :start_tag, :end_tag, :comment, :whitespace, :character, :null, :eof ]

  enum :gumbo_quirks_mode, [ :no_quirks, :quirks, :limited_quirks ]

  class GumboVector < FFI::Struct
    layout :data,     :pointer,
           :length,   :uint,
           :capacity, :uint

    def length
      self[:length]
    end

    def data
      self[:data].type_size
    end
  end

  class GumboTokenizerError < FFI::Struct
    layout :codepoint, :int,
           :state,     :gumbo_tokenizer_error_state
  end

  class GumboParserError < FFI::Struct
    layout :input_type,   :gumbo_token_type,
           :input_tag,    :gumbo_tag,
           :parser_state, :gumbo_insertion_mode,
           :tag_stack,    GumboVector
  end

  class GumboDuplicateAttrError < FFI::Struct
    layout :name,           :string,
           :original_index, :uint,
           :new_index,      :uint
  end

  class GumboSourcePosition < FFI::Struct
    layout :line,   :uint,
           :column, :uint,
           :offset, :uint
  end

  class GumboStringPiece < FFI::Struct
    layout :data, :pointer, #string
           :length, :size_t
  end

  class GumboDocument < FFI::Struct
    layout :children,             GumboVector,
           :has_doctype,          :bool,
           :name,                 :string,
           :public_identifier,    :string,
           :system_identifier,    :string,
           :doc_type_quirks_mode, :gumbo_quirks_mode

    def children
      self[:children]
    end

    def has_doctype
      self[:has_doctype]
    end

    def name
      self[:name]
    end
  end

  class GumboElement < FFI::Struct
    layout :children,         GumboVector,
           :tag,              :gumbo_tag,
           :tag_namespace,    :gumbo_namespace_enum,
           :original_tag,     GumboStringPiece,
           :original_end_tag, GumboStringPiece,
           :start_pos,        GumboSourcePosition,
           :end_pos,          GumboSourcePosition
  end

  class GumboText < FFI::Struct
    layout :text,          :pointer, # string
           :original_text, GumboStringPiece,
           :start_pos,     GumboSourcePosition
  end

  class GumboErrorUnion < FFI::Union
    layout :tokenizer,      GumboTokenizerError,
           :text,           GumboStringPiece,
           :duplicate_attr, GumboDuplicateAttrError,
           :parser,         GumboParserError
  end

  class GumboError < FFI::Struct
    layout :type,          :gumbo_error_type,
           :position,      GumboSourcePosition,
           :original_text, :pointer,
           :info,          GumboErrorUnion
  end

  class GumboNodeUnion < FFI::Union
    layout :document, GumboDocument,
           :element,  GumboElement,
           :text,     GumboText

    def document
      self[:document]
    end

    def element
      self[:element]
    end

    def text
      self[:text]
    end
  end

  class GumboNode < FFI::Struct
    layout :type,                :gumbo_node_type,
           :parent,              :pointer, #GumboNode
           :index_within_parent, :size_t,
           :parse_flags,         :gumbo_parse_flags,
           :_data,                GumboNodeUnion

    def parse_flags
      self[:parse_flags]
    end

    def data
      case self[:type]
      when :node_document
        self[:_data].document
      when :node_element
        self[:_data].element
      when :node_text
        self[:_Data].text
      end
    end
  end

  class GumboOutputStruct < FFI::Struct
    layout :_document, :pointer, #GumboNode,
           :_root,     :pointer, #GumboNode,
           :errors,   GumboVector

    def document
      Dumbo::GumboNode.new(self[:_document])
    end

    def root
      Dumbo::GumboNode.new(self[:_root])
    end

    def errors
      self[:errors]
    end
  end

  #attach_function "gumbo_parse", [:string], GumboOutputStruct.
  attach_function "gumbo_parse", [:string], :pointer

  def self.parse(input)
    Dumbo::GumboOutputStruct.new(gumbo_parse(input))
  end
end
