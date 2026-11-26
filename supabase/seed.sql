-- MOZHIVORA Seed Data: Starter Public Templates (EN, HI, UR)

INSERT INTO public.templates (user_id, title, category, role_tag, locale, tone, prompt_body, is_public)
VALUES
  (NULL, 'Chapter Revision Notes', 'Study', 'student', 'en', 'clear', 'Summarize this chapter into key concepts, definitions, and 5 practice questions.', TRUE),
  (NULL, 'Executive Project Update', 'Reports', 'professional', 'en', 'concise', 'Turn these bullet points into a clear weekly status update with blockers and next steps.', TRUE),
  (NULL, 'अध्याय सारांश और प्रश्नोत्तरी', 'Study', 'student', 'hi', 'clear', 'इस अध्याय का सरल हिंदी में सारांश और 5 अभ्यास प्रश्न तैयार करें।', TRUE),
  (NULL, 'سبق کا خلاصہ اور فلیش کارڈز', 'Study', 'student', 'ur', 'clear', 'اس سبق کا مختصر خلاصہ اور 5 اہم فلیش کارڈز اردو میں تیار کریں۔', TRUE);
