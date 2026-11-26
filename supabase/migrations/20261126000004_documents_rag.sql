-- MOZHIVORA Phase 4: Private Storage Bucket & pgvector RAG Match RPC

INSERT INTO storage.buckets (id, name, public, file_size_limit)
VALUES ('user-documents', 'user-documents', FALSE, 52428800)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "user_documents_owner_select" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'user-documents'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "user_documents_owner_insert" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'user-documents'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "user_documents_owner_delete" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'user-documents'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE INDEX IF NOT EXISTS idx_document_chunks_embedding
  ON public.document_chunks USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

CREATE OR REPLACE FUNCTION public.match_document_chunks(
  p_query_embedding vector(768),
  p_document_ids UUID[] DEFAULT NULL,
  p_match_count INT DEFAULT 6,
  p_min_similarity FLOAT DEFAULT 0.45
)
RETURNS TABLE (
  chunk_id UUID,
  document_id UUID,
  document_title TEXT,
  page_number INT,
  content TEXT,
  similarity FLOAT
)
LANGUAGE sql
STABLE
SECURITY INVOKER
AS $$
  SELECT
    dc.id AS chunk_id,
    dc.document_id,
    d.title AS document_title,
    dc.page_number,
    dc.content,
    1 - (dc.embedding <=> p_query_embedding) AS similarity
  FROM public.document_chunks dc
  JOIN public.documents d ON d.id = dc.document_id
  WHERE dc.user_id = auth.uid()
    AND d.deleted_at IS NULL
    AND (p_document_ids IS NULL OR dc.document_id = ANY(p_document_ids))
    AND 1 - (dc.embedding <=> p_query_embedding) >= p_min_similarity
  ORDER BY dc.embedding <=> p_query_embedding
  LIMIT p_match_count;
$$;
