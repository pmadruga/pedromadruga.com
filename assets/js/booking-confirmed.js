/* Fills in the invitee's name on /booking/confirmed/.

   meetergo appends the invitee's details to the redirect URL when "Pass
   event details to redirect URL" is enabled. This reads the name out of the
   query string and drops it into the greeting.

   Degrades on purpose: with no parameter, no JS, or an unrecognised key, the
   span stays empty and the sentence still reads "Thanks for booking."

   textContent, never innerHTML: the value comes from the query string and is
   therefore attacker-controllable. */
(function () {
  var slot = document.querySelector('[data-invitee-name]');
  if (!slot || !window.URLSearchParams) return;

  var params = new URLSearchParams(window.location.search);

  /* Key names per meetergo's booking-redirect docs: it appends
     invitee_first_name / invitee_full_name / invitee_last_name (alongside
     invitee_email, invitee_uuid, event_* and answer_1..10). The generic
     fallbacks are only there in case the provider changes. */
  var keys = ['invitee_first_name', 'invitee_full_name', 'name', 'invitee_name'];
  var value = '';
  for (var i = 0; i < keys.length; i++) {
    value = params.get(keys[i]) || '';
    if (value) break;
  }

  value = value.trim();
  if (!value) return;

  /* First name only, and capped: the greeting should stay a greeting even if
     someone hand-edits the URL. */
  var first = value.split(/\s+/)[0].slice(0, 40);

  /* Bail unless it still looks like a name. textContent already makes markup
     inert, but "Thanks for booking, <img." would be a silly thing to show. */
  if (!/^[\p{L}\p{M}][\p{L}\p{M}'’.-]*$/u.test(first)) return;

  slot.textContent = ', ' + first;
})();
