# frozen_string_literal: true

module ModalHelper
  MODAL_ID        = "modal"
  DEFAULT_OPTIONS = { data: { turbo_frame: MODAL_ID, action: "modal#showModal", modal_type: "" } }.freeze

  def modal_tag(modal_id = MODAL_ID)
    turbo_frame_tag modal_id, data: { modal_target: "turboFrame" }
  end

  def modal_link_to(name = nil, options = nil, html_options = nil, &block)
    if block
      link_to name, DEFAULT_OPTIONS.deep_merge(options || {}), html_options, &block
    else
      link_to name, options, DEFAULT_OPTIONS.deep_merge(html_options || {}), &block
    end
  end

  def modal_link(text = nil, path = nil, options = {}, &block)
    options = DEFAULT_OPTIONS.deep_merge(options)
    if block
      link_to text || path, options, &block
    else
      link_to text, path, options
    end
  end

  def modal_content(options = {}, &block)
    modal_id = options.fetch(:modal_id, MODAL_ID)
    turbo_frame_tag modal_id, class: "hidden" do
      tag.div(class: "modal animate-in #{options.delete(:modal_classes)}",
              data:  {
                action: "keyup@document->modal#keyup scrim-hide@window->modal#close",
              }) do
        yield if block
      end
    end
  end
end
